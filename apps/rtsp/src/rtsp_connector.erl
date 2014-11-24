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
  io:format("start_link"),
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(Socket) ->
  io:format("init",[]),
  gen_server:cast(self(),accept),
  {ok, Args}.

handle_call(_Request, _From, State) ->
  io:format("handle_call ~n", [_Request]),
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  io:format("handle_cast ~p /n", [_Msg]),
  {noreply, State}.

handle_info(_Info, State) ->
  io:format("handle_info ~n", [_Info]),
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("terminate ~n", [_Reason]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  io:format("code_change ~n"),
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

