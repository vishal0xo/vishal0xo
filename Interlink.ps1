    $list1 = "C:\Users\vm37\Desktop\Scripts\list1.txt"
    $item = get-content $list1
    $count = 1
    
    $Input_1 = Read-Host  "Enter the change number"
    $Input_2 = Read-Host  "enter the record name"
    $Input_3 = Read-Host  "Enter the start date"
    $Input_4 = Read-Host  "Enter the end date" 

    $Input_5 = Read-Host  "Enter the action type"
    $Input_6 = Read-Host  "Enter the Etype"
    
    write-host "<NR>"
    Write-host "<change>$Input_1</change>"c
    Write-Host "<rdname>$Input_2</rdname>"
    write-host "<sdate>$Input_3</sdate>"
    write-host "<edate>$Input_4</edate>"
    write-host "<action>$Input_5</action>"
    write-host "<etype>$Input_6</etype>"
    write-host "<selector>"

    foreach ($item1 in $item) {

    Write-Output "<sel>{s$count}</sel>"
    Write-Output "     <sel>_domain eq $item1</sel>"

    $count++

    }
    write-host "</selector>"
    write-host "<startedby>puppet</startedby>"
    write-host "</NR>"

