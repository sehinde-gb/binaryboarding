Class New.Seats Extends %Persistent
{

ClassMethod Startline(Number As %Integer)
{
        set line(3) = "FFFFFBFLLR"
        set line(2) = "FBFBFFBRLL"
        set line(1) = "BBFFBFBLRL"


        write !, "Starting replacement loop"

        For i=1:1:3 {
            write !,(i)
             set line(i)=$REPLACE(line(i),"F","0")
             set line(i)=$REPLACE(line(i),"B","1")
             set line(i)=$REPLACE(line(i),"L","0")
             set line(i)=$REPLACE(line(i),"R","1")
             write !, line(i)
             write !,"counter set to ",(i)
        }
        write !, "Ended replacement loop"

        write !, "Entering ordering and extraction loop"

        set i = 1
        // Get first array
        set key=$ORDER(line(""))
        WHILE (key'="") {
            write !,*32
            write "Key:",key,!
            // Get next next 
            set key = $ORDER(line(key))
            set column = $EXTRACT(line(i),1,7)
            set row = $EXTRACT(line(i),*-2,*)
            write "Row:", row ,!
            write "Column:",column ,!

            SET Result = 0 
            SET Power = 1 
            write "Result:",Result ,!
            //FOR i=$LENGTH(line(i)):-1:1 { 
            //SET Result = Result + ( $EXTRACT(line(i),i)* Power ) 
            //SET Power = Power * 2 
            //} 
            //WRITE "Result:",Result,! 
            //set i = $INCREMENT(i)
}
        write !, "Leaving ordering and extraction loop"
}

Storage Default
{
<Data name="SeatsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^New.SeatsD</DataLocation>
<DefaultData>SeatsDefaultData</DefaultData>
<IdLocation>^New.SeatsD</IdLocation>
<IndexLocation>^New.SeatsI</IndexLocation>
<StreamLocation>^New.SeatsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
