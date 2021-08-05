Class Binary.Boarding Extends %Persistent
{

ClassMethod Replacement()
{
        // We set up an array containing 3 binary lines
        set line(1) = "FFFFFBFLLR"
        set line(2) = "FBFBFFBRLL"
        set line(3) = "BBFFBFBLRL"


        // Next we set up a replacement loop that will replace the letters F B L R with binary digits
        // We create 2 new variables to hold the row and column and then extract 7 characters 
        // to represent the row and the last 3 characters for the column.
        // Finally we call the conversion method for the rows and columns.
        write !, "Starting replacement loop"

        for i=1:1:3 {
            write !,(i)
            set line(i)=$REPLACE(line(i),"F","0")
            set line(i)=$REPLACE(line(i),"B","1")
            set line(i)=$REPLACE(line(i),"L","0")
            set line(i)=$REPLACE(line(i),"R","1")
            write !, line(i)
            write !,"counter set to ",(i)
            write !,*32
            set row = $EXTRACT(line(i),1,7)
            set column = $EXTRACT(line(i),*-2,*)
            write "Row:", row ,!
            write "Column:",column ,!
                
            do ##class(New.Seats).Conversion(.row,.column)  
        }
        
        
        write !, "Ended replacement loop"
}

ClassMethod Conversion(ByRef column As %Binary, ByRef row As %Binary)
{

 /// set up the variables and initialise them
    set ColResult = 0
    set RowResult = 0
    set Power = 1
    set i=1
    //set CNumber = column
    set CNumber(i) = column
    set RNumber(i) = row
    //set RNumber = row
    write "Column Number:",CNumber(i) ,!
    write "Row Number:",RNumber(i) ,!

/// set up a for loop to extract the column result and convert it in to decimalised format

    set ColResult = ZCONVERT(ColResult)
    set RowResult = ZCONVERT(RowResult)
    write ColResult,!
    write RowResult,!
    
    //for i=$LENGTH(CNumber):-1:1 {
        //set ColResult = ColResult + ( $EXTRACT(CNumber(i))* Power )
        //set Power = Power * 2

        //}
    //for i=$LENGTH(RNumber):-1:1 {
        //set RowResult = RowResult + ( $EXTRACT(RNumber(i))* Power )
        //set Power = Power * 2
  //  }
    //write "The column result is:",ColResult(i),!
    //write "The row result is:",RowResult(i),!
/// Calls the CalculateSeats method passing in the Column and Row results as parameters
   // do ##class(New.Seats).CalculateSeats(.ColResult,.RowResult)
    //set i = $INCREMENT(i)
}

/// set up a for loop to extract the row result and convert it in to decimalised format
ClassMethod CalculateSeats(ByRef RowResult As %Integer, ByRef ColResult As %Integer)
{
/// Calculate the seat ID based on the Row and Column result parameters
    set seatID = RowResult * 8 + ColResult
    write "SeatID:", seatID
}

Storage Default
{
<Data name="BoardingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Binary.BoardingD</DataLocation>
<DefaultData>BoardingDefaultData</DefaultData>
<IdLocation>^Binary.BoardingD</IdLocation>
<IndexLocation>^Binary.BoardingI</IndexLocation>
<StreamLocation>^Binary.BoardingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
