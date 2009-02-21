-module (spearman).
-behaviour (similarity).
-export ([correlate/2]).

correlate (List1, List2) ->
    {TR1,_} = lists:unzip(utils:ordered_ranks_of(List1)),
    {TR2,_} = lists:unzip(utils:ordered_ranks_of(List2)),

    Numerator = 6 * lists:sum([ (D1-D2)*(D1-D2) || {D1,D2} <- lists:zip(TR1,TR2) ]),
    Denominator = math:pow(length(List1),3)-length(List2),

    1 - Numerator/Denominator.