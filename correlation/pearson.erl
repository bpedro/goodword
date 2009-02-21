-module (pearson).
-behaviour (similarity).
-export ([correlate/2]).

correlate (List1, List2) ->
    SumXY = lists:sum([A*B || {A,B} <- lists:zip(List1, List2) ]),

    SumX = lists:sum(List1),
    SumY = lists:sum(List2),
    
    SumXX = lists:sum([L*L || L<-List1]),
    SumYY = lists:sum([L*L || L<-List2]),
    
    N = length(List1),
    
    Numer = (N*SumXY) - (SumX * SumY),
    Denom = math:sqrt(((N*SumXX)-(SumX*SumX)) * ((N*SumYY)-(SumY*SumY))),

    Numer/Denom.