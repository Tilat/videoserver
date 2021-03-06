-module(videoserver_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

-import(error_logger, [format/2, error_msg/1, info_msg/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  {ok,
    {{one_for_one, 5, 10},
      [
        {videosrv, {videosrv, start_link, []},
          permanent, 1000, worker, [videosrv]}
      ]
    }
  }.


