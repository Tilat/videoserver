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
{ok, Port} = {ok,8554},
%% Set the socket into {active_once} mode.
%% See sockserv_serv comments for more details
{ok, ListenSocket} = gen_tcp:listen(Port, [{active,once}, {packet,line}]),
spawn_link(fun empty_listeners/0),
{ok, {{simple_one_for_one, 60, 3600},
[{sockserv_serv,
{sockserv_serv, start_link, [ListenSocket]}, % pass the socket!
temporary, 1000, worker, [sockserv_serv]}
]}}.

start_socket() ->
supervisor:start_child(?MODULE, []).

empty_listeners() ->
[start_socket() || _ <- lists:seq(1,20)],
ok.
