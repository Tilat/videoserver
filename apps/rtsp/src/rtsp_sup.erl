-module(rtsp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,start_socket/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  {ok, Port} = {ok, 8554},
  {ok, RTSPSocket} = gen_tcp:listen(Port, [{active,once}, {packet,line} ]),
  spawn_link(fun empty_listeners/0),
  {ok, {{simple_one_for_one, 60, 3600},
    [{rtsp_connector,
      {rtsp_connector, start_link, [RTSPSocket]}, % pass the socket!
      temporary, 1000, worker, [rtsp_connector]}
    ]}
  }.


start_socket() ->
  supervisor:start_child(?MODULE, []).

empty_listeners() ->
  [start_socket() || _ <- lists:seq(1,5)],
  ok.