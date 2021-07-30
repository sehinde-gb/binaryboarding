Class New.Seats Extends %Persistent
{

ClassMethod Startline()
{
      
        set lines(1) = "FFFFFBFLLR"
        set lines(2) = "FBFBFFBRLL"
        set lines(3) = "BBFFBFBLRL"

        

        write !, "Starting loop"

        For i=1:1:3 {
            write !,(i)
            set lines(i)=$REPLACE(lines(i),"F","0")
            set lines(i)=$REPLACE(lines(i),"B","1")
            set lines(i)=$REPLACE(lines(i),"L","0")
            set lines(i)=$REPLACE(lines(i),"R","1")
            write !, lines(i)
            write !,"counter set to ",(i)
        }

        write !, "loop ended"
}

/// Description
Storage Default
{
<Data name="SeatsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^New.SeatsD</DataLocation>
<DefaultData>SeatsDefaultData</DefaultData>
<Description>
<![CDATA[Description]]></Description>
<IdLocation>^New.SeatsD</IdLocation>
<IndexLocation>^New.SeatsI</IndexLocation>
<StreamLocation>^New.SeatsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
