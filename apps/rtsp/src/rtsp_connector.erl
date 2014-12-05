-module(rtsp_connector).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-record(session, {id, % id
  socket}). % the current socket

-import(error_logger, [info_msg/1, info_msg/2]).
%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(Socket) ->
  io:format("rtsp_connector:start_link - ~p", [Socket]),
  gen_server:start_link({local, ?SERVER}, ?MODULE, Socket, []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(Socket) ->
  io:format("rtsp_connector:init - socket=~p", [Socket]),
  gen_server:cast(self(), accept),
  {ok, #session{id = erlang:now(), socket = Socket}}.


%% ========================================
handle_call(Req, From, State) ->
  error_logger:info_msg("rtsp_connector:handle_call -  ~p, ~p, ~p", [Req, From, State]),
  {noreply, State}.
%% ========================================


%% ========================================
handle_cast(accept, Session = #session{socket = Socket}) ->
  error_logger:info_msg("rtsp_connector:handle_cast - Accepting connection \n"),
  {ok, AcceptedSocket} = gen_tcp:accept(Socket),
  rtsp_sup:start_socket(),
  error_logger:info_msg("rtsp_connector:handle_cast - Got a new incomming connection ~p\n", [AcceptedSocket]),
  inet:setopts(AcceptedSocket, [{active, once}]),
  {noreply, Session#session{socket = AcceptedSocket}}.
%% ========================================


%% ========================================
handle_info({tcp_closed,Socket}, State) ->
  error_logger:info_msg("rtsp_connector:handle_info - socket=~p, State=~p", [Socket, State]),
  {stop, normal, State};
%% ----------------------------------------
handle_info({tcp_error,Socket, _}, State) ->
  error_logger:info_msg("rtsp_connector:handle_info - socket=~p, State=~p", [Socket, State]),
  {stop, normal, State};
%% ----------------------------------------
handle_info({tcp, Socket, String}, Session = #session{socket=Socket} ) ->
  error_logger:info_msg("rtsp_connector:handle_info - ~p, ~p", [String, Session]),
  send(Socket, "response",[]),
  {noreply, Session}.
%% ========================================


terminate(Reason, State) ->
  error_logger:info_msg("rtsp_connector:terminate - ~p, ~p", [Reason, State]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  error_logger:info_msg("rtsp_connector:code_change\n"),
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------


%% Send a message through a socket, then make it active again.
%% The difference between an active and a passive socket is that
%% an active socket will send incoming data as Erlang messages, while
%% passive sockets will require to be polled with gen_tcp:recv/2-3.
%%
%% Depending on the context, you might want one or the other. I chose
%% to have active sockets because they feel somewhat easier to work
%% with. However, one problem with active sockets is that all input
%% is blindly changed into messages and makes it so the Erlang VM
%% is somewhat more subject to overload. Passive sockets push this
%% responsibility to the underlying implementation and the OS and are
%% somewhat safer.
%%
%% A middle ground exists, with sockets that are 'active once'.
%% The {active, once} option (can be set with inet:setopts or
%% when creating the listen socket) makes it so only *one* message
%% will be sent in active mode, and then the socket is automatically
%% turned back to passive mode. On each message reception, we turn
%% the socket back to {active once} as to achieve rate limiting.
send(Socket, Str, Args) ->
  ok = gen_tcp:send(Socket, io_lib:format(Str ++ "~n", Args)),
  ok = inet:setopts(Socket, [{active, once}]),
  ok.
