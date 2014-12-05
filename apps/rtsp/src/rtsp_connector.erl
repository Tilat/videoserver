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
gen_server:start_link(?MODULE, Socket, []).

init(Socket) ->
%% properly seeding the process
%% Because accepting a connection is a blocking function call,
%% we can not do it in here. Forward to the server loop!
gen_server:cast(self(), accept),
{ok, #state{socket=Socket}}.


%% We never need you, handle_call!
handle_call(_E, _From, State) ->
{noreply, State}.


handle_cast(accept, S = #state{socket=ListenSocket}) ->
{ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
%% Remember that thou art dust, and to dust thou shalt return.
%% We want to always keep a given number of children in this app.
socktest_sup:start_socket(), % a new acceptor is born, praise the lord
ok = inet:setopts(AcceptSocket, [{active, once}]),
%send(AcceptSocket, "hello", []),
{noreply, S#state{socket=AcceptSocket, next=name}}.

handle_info({tcp_closed, _Socket}, S) ->
{stop, normal, S};
handle_info({tcp_error, _Socket, _}, S) ->
{stop, normal, S};
handle_info({tcp, Socket, Str}, S = #state{socket=Socket}) ->
send(Socket, "response", []),
{noreply, S}.
%;
%handle_info(M,S) ->
%io:format("unexpected: ~p~n", [M]),
%{noreply, S}.


terminate(_Reason, _State) ->
io:format("terminate reason: ~p~n", [_Reason]).

code_change(_OldVsn, State, _Extra) ->
{ok, State}.

send(Socket, Str, Args) ->
ok = gen_tcp:send(Socket, io_lib:format(Str++"~n", Args)),
ok = inet:setopts(Socket, [{active, once}]),
ok.
