-module(rtsp_connector).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-import(error_logger, [info_msg/1]).
%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
  error_logger:info_msg("start_link"),
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------


%% case gen_tcp:listen(Port, Opts2) of
%% {ok, ListenSocket} ->
%% {ok, Ref} = prim_inet:async_accept(ListenSocket, -1),
%% {noreply, Server#listener{addr = BindAddr, port = Port, socket = ListenSocket, ref = Ref}};
%% {error, eaccess} ->
%% error_logger:error_msg("Error connecting to port ~p. Try to open it in firewall or run with sudo.\n", [Port]),
%% {stop, eaccess, Server};
%% {error, Reason} ->
%% {stop, Reason, Server}
%% end;


init(Args) ->
  error_logger:info_msg("init"),
  gen_server:cast(rtsp_connector, {bindToSocket, localhost, 8554}),
  {ok, Args}.

handle_call(_Request, _From, State) ->
  error_logger:info_msg("handle_call ~n", [_Request]),
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  error_logger:info_msg("handle_cast ~p ~n", [_Msg]),
  case _Msg of
    {bindToSocket, Address, Port} -> bindSocket(Address, Port);
    _ -> error_logger:infor("Unknown command")
  end,
  {noreply, State}.

handle_info(_Info, State) ->
  error_logger:info_msg("handle_info ~n", [_Info]),
  {noreply, State}.

terminate(_Reason, _State) ->
  error_logger:info_msg("terminate ~n", [_Reason]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  error_logger:info_msg("code_change ~n"),
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

bindSocket(Address, Port) ->

  {ok, Socket} = gen_tcp:listen(Port, [{active,false}])

%%  TODO Rewrite the code
%%     {ok, Socket} = gen_tcp:listen(8554, [{active,false}]),
%%     error_logger:info_msg("Socket for RTSP is openned"),
%% case gen_tcp:listen(Port, Opts2) of
%% {ok, ListenSocket} ->
%% {ok, Ref} = prim_inet:async_accept(ListenSocket, -1),
%% {noreply, Server#listener{addr = BindAddr, port = Port, socket = ListenSocket, ref = Ref}};
%% {error, eaccess} ->
%% error_logger:error_msg("Error \n", [Port]),
%% {stop, eaccess, Server};
%% {error, Reason} ->
%% {stop, Reason, Server}
%% end;

  error_logger:info_msg("bindSocket ~p", [Port]),
  ok.