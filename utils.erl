-module (utils).
-export ([intersect/2]).
-export ([get_values/2]).
-export ([ranks_of/1]).
-export ([tied_ranks_of/1]).
-export ([tied_add_prev/2]).
-export ([tied_rank_worker/3]).
-export ([ordered_ranks_of/1]).
-export ([ksum/2]).

intersect([], _) -> [];
intersect([H|T], List) ->
    case lists:member(H, List) of
        true -> [H | intersect(T, List)];
        false -> intersect(T, List)
    end.

get_values ([], _) -> [];
get_values ([H|T], List) ->
    case proplists:is_defined(H, List) of
        true -> [proplists:get_value(H, List) | get_values(T, List)];
        false -> get_values(T, List)
    end.

ranks_of(List) when is_list(List) ->
    lists:zip(lists:seq(1,length(List)),lists:reverse(lists:sort(List))).

tied_ranks_of(List) ->
    tied_rank_worker(ranks_of(List), [], no_prev_value).

tied_add_prev(Work, {FoundAt, NewValue}) ->
    lists:duplicate(
        length(FoundAt),
        {lists:sum(FoundAt) / length(FoundAt), NewValue}
    ) ++ Work.

tied_rank_worker([], Work, PrevValue) ->
    lists:reverse(tied_add_prev(Work, PrevValue));

tied_rank_worker([Item|Remainder], Work, PrevValue) ->
    case PrevValue of
        no_prev_value ->
            {BaseRank,BaseVal} = Item,
            tied_rank_worker(Remainder, Work, {[BaseRank],BaseVal});
        {FoundAt,OldVal} ->
            case Item of
                {Id,OldVal} ->
                    tied_rank_worker(
                        Remainder,
                        Work,
                        {[Id]++FoundAt,OldVal});
                {Id,NewVal} ->
                    tied_rank_worker(Remainder,
                        tied_add_prev(Work, PrevValue),
                        {[Id],NewVal})
            end
    end.

ordered_ranks_of(List) when is_list(List) ->
    ordered_ranks_of(List, tied_ranks_of(List), []).

ordered_ranks_of([], [], Work) ->
    lists:reverse(Work);

ordered_ranks_of([Front|Rem], Ranks, Work) ->
    {value,Item} = lists:keysearch(Front,2,Ranks),
    {IRank,Front} = Item,
    ordered_ranks_of(Rem, Ranks--[Item], [{IRank,Front}]++Work).

ksum(List1, List2) ->
    ksum(List1, List2, []).

ksum ([], _, Total) ->
    lists:reverse(Total);

ksum ([H1|T1], List2, Total) ->
    {Key, Val} = H1,
    ksum (T1, List2, [{Key, Val + proplists:get_value(Key, List2, 0)} | Total]).