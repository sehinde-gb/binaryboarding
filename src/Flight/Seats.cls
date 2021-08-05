Class Flight.Seats Extends %Persistent
{

Storage Default
{
<Data name="SeatsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Flight.SeatsD</DataLocation>
<DefaultData>SeatsDefaultData</DefaultData>
<IdLocation>^Flight.SeatsD</IdLocation>
<IndexLocation>^Flight.SeatsI</IndexLocation>
<StreamLocation>^Flight.SeatsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
