$mypsval = "hello world"
echo ${arg1} ${arg2} ${arg3} >> C:\tfscriptoutput.txt
echo ${arg3} ${arg2} ${arg1} >> C:\tfscriptoutput2.txt
$mypsval2 = ${arg1}
echo $mypsval2 $mypsval >> C:\tfscriptoutput3.txt
