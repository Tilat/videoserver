-module(videosrv).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).


-import(error_logger, [format/2,error_msg/1,info_msg/1]).
%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
  error_logger:error_msg("Something happened in method start_link ~p~n"), 
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(Args) ->
  io:format("in service", []),
  {ok, Args}.

handle_call(_Request, _From, State) ->
  io:format("in service", []),
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  io:format("in service", []),
  {noreply, State}.

handle_info(_Info, State) ->
  io:format("in service", []),
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("in service", []),
  erlang:display("handle_cast() from gen_server"),
  ok.

code_change(_OldVsn, State, _Extra) ->
  io:format("in service", []),
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
