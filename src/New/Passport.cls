Class New.Passport Extends %Persistent
{

ClassMethod ImportPassports(dir As %String = "/usr/local/day4.txt")
{
    // Open my text file and check it exists
    IF ##class(%File).Exists(dir) '=1 {
    write !, "Unable to Open: "_dir
    QUIT}
    ELSE { write "File: "_dir_" is open"
    }

    // instantiate a new class called file
    set file = ##class(%Stream.FileCharacter).%New()
    // create a new variable called sc
    set sc = file.LinkToFile(dir)
    set count=1
    /// loop to go through each line and save it to a global that increments
    
    WHILE ('file.AtEnd) && ('file '= "")
    {
        set delim=" "
        set line = file.ReadLine()
        write !, "Loop started"
        set ^namelist(count)=$LISTFROMSTRING(line, delim)
        set countdown=$LENGTH(line,delim)
        set count=$INCREMENT(count)

        
        write !,*32
        write !, "Double checking to see if the fields are set"
        write !,*32
        write !, "1st element of 2nd global", $LIST(^namelist(2),1)
        write !, "2nd element of 4th global ", $LIST(^namelist(4),2)
        write !, "1st element of 5th global", $LIST(^namelist(5),1)
        write !, "1st element of 8th global", $LIST(^namelist(8),1)
    
        write !, "Import process complete"
    }
}

ClassMethod ProcessPassports()
{
                
                write "Passport 1",!
                write !,*32
                /// Concatenate and save the globals in to one array 
                set passport1=^namelist(1)_^namelist(2)
                /// Build the list
                set lista=$LISTBUILD("ecl:gry", "pid:860033327", "eyr:2020", "hcl:#fffffd","byr:1937", "iyr:2017", "cid:147", "hgt:183cm")
                /// Comparison to check to see if the lists are the same
                if passport1=lista{write "The list's are identical",!}
                ELSE {write "The list's are not identical",!}
                write !,*32
                /// Explain why the lists are not the same
                write "List Length: ",$LISTLENGTH(passport1)
                write !,*32
                write !,"Your passport is valid" 
                write !,*32

                /// Concatenate and save the globals in to one array and then use an if statement
                /// to determine if the lists are identical or not.
                /// if they are identical then show a message to the screen
                /// use list find to see if a missing field is there or not and if it is not
                /// display a message to the screen
                write !,*32
                write "Passport 2",!
                write !,*32
                set passport2=^namelist(4)_^namelist(5)
                set listb=$LISTBUILD("iyr:2013", "ecl:amb", "cid:350", "eyr:2023", "pid:028048884","hcl:#cfa07d", "byr:1929")
                if passport2=listb {write "The list's are identical",!}
                ELSE {write "The list's are not identical",!}
                write !,*32
                write "List Length: ",$LISTLENGTH(passport2)
                if $LISTFIND(lista,"hgt: ")=0{ write !,*32 write "Your passport is missing a hgt field and this means we won't be processing your passport this time" }
                write !,*32
                
                write !,*32
                write "Passport 3",!
                write !,*32
                set passport3=^namelist(7)_^namelist(8)_^namelist(9)_^namelist(10)
                set listb=$LISTBUILD("hcl:#ae17e1","iyr:2013","eyr:2024","ecl:brn","pid:760753108","byr:1931","hgt:179cm")
                if passport3=listb {write "The list's are identical",!}
                ELSE {write "The list's are not identical",!}
                write "List Length: ",$LISTLENGTH(passport3)
                if $LISTFIND(listb,"cid:")=0{ write !,*32 write "No cid in this case we will make an exception and we will validate your passport"}
                
                
                write !,*32
                
                write !,*32
                write "Passport 4",!
                write !,*32
                
                set passport4=^namelist(12)_^namelist(13)
                set listc=$LISTBUILD("hcl:#cfa07d", "eyr:2025", "pid:166559648", "iyr:2011", "ecl:brn", "hgt:59in")
                if passport4=listc {write "The list's are identical",!}
                ELSE {write "The list's are not identical",!}
                write "List Length: ",$LISTLENGTH(passport4)
                if $LISTFIND(listc,"cid:")=0 && $LISTFIND(listc,"byr")=0{ write !,*32 write "Your passport is missing the cid & byr so your passport is invalid" }
}

Storage Default
{
<Data name="PassportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WholeLine</Value>
</Value>
<Value name="3">
<Value>Passport2</Value>
</Value>
</Data>
<DataLocation>^New.PassportD</DataLocation>
<DefaultData>PassportDefaultData</DefaultData>
<IdLocation>^New.PassportD</IdLocation>
<IndexLocation>^New.PassportI</IndexLocation>
<StreamLocation>^New.PassportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
