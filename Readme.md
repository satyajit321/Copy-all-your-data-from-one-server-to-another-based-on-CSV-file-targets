<p><strong>.Synopsis</strong><br /> &nbsp;&nbsp; This script will copy all your data from one server to another, based on the import list provided in&nbsp;a CSV file. Its targetted to requirements when you have multiple sources and destination is one. <br /> <strong>&nbsp;</strong></p>
<p><strong>.DESCRIPTION</strong><br /> It can be part of a larger script\tool which generates sample \template data and requires them to be copied into freshly&nbsp;deployed server.</p>
<p><br /> Copy has -force added which overwrites folders, otherwise the normal behavior for Copy-Item will only overwrite the destination file (with or without -Force).</p>
<p>Refer to <a href="https://gallery.technet.microsoft.com/scriptcenter/Generate-CSV-Sample-Input-900c6a83" target="_blank"> this script to generate the sample input file</a> or use the attached ones.</p>
<ul>
<li>Default InputFile Name: <a id="142778" href="/scriptcenter/site/view/file/142778/1/Importpath.csv"> Importpath.csv</a> </li>
<li>Generated Sample: <a id="142779" href="/scriptcenter/site/view/file/142779/1/Sample_ImportPath.csv"> Sample_ImportPath.csv</a> </li>
<li>Sample CSV input format generator:&nbsp;<a href="https://gallery.technet.microsoft.com/scriptcenter/Generate-CSV-Sample-Input-900c6a83" target="_blank">GenerateCSV</a> </li>
<li>Default Output file: <a id="142780" href="/scriptcenter/site/view/file/142780/1/ResultStatus.csv"> ResultStatus.csv</a> </li>
<li>Custom result filename: <a id="142781" href="/scriptcenter/site/view/file/142781/1/rest.csv"> rest.csv</a> </li>
</ul>
<p><strong>It has different response types depending on the error:</strong></p>
<ul>
<li>Source file missing or The network path was not found. </li>
<li>Folder does not exist <a href="file://\\localhost\C$\Test\DestData">\\localhost\C$\Test\DestData</a> </li>
<li>Error on creating directory <a href="file://\\localhost\C$\Test\DestData">\\localhost\C$\Test\DestData</a> </li>
</ul>
<p>It has basic error handling capabilities, like unresponsive server, missing folders, files and Access Denied cases.</p>
<p>It supports <strong>-Verbose</strong> and <strong>-Whatif</strong> switches and handles data as expected.</p>
<ul>
<li>Source: Can be local C:\Folder\ or UNC <a href="file://\\Server01\C$\Folder"> \\Server01\C$\Folder</a> </li>
<li>Destination: Has to be Local </li>
</ul>
<p>*It features a<strong>&nbsp;Progress bar</strong> based on the input data object count</p>
<p>Refer to various examples to learn more upon the usage.</p>
<p><br /> <strong>.INPUTS</strong><br /> &nbsp;&nbsp; Inputs to this cmdlet (if any) - Filename or full path or blank (Defaultname would be used)<br /> &nbsp;&nbsp; Importpath.csv<br /> &nbsp;&nbsp;&nbsp; #File Format Starts----------------<br /> Source,Destination,DestnationServer<br /> <a href="file://\\Server-1\C$\Test\CopyData,C:\Test\DestData,Server-1">\\Server-1\C$\Test\CopyData,C:\Test\DestData,Server-1</a><br /> C:\Test\CopyData,C:\Test\DestData,Server-1<br /> &nbsp;&nbsp;&nbsp; #File Format Ends------------------</p>
<p>Source: Can be local C:\Folder\ or UNC <a href="file://\\Server01\C$\Folder">\\Server01\C$\Folder</a><br /> Destination: Has to be Local</p>
<p><strong>.OUTPUTS</strong></p>
<p>Filename ,path or blank.</p>
<p>Result.csv</p>
<div class="scriptcode">
<div class="pluginEditHolder" pluginCommand="mceScriptCode">
<div class="title"><span>PowerShell</span></div>
<div class="pluginLinkHolder"><span class="pluginEditHolderLink">Edit</span>|<span class="pluginRemoveHolderLink">Remove</span></div>
<span class="hidden">powershell</span>
<pre class="hidden">.EXAMPLE
.\CopyPath.ps1
 
.EXAMPLE
.\CopyPath.ps1 -InputFile Otherpathfile.csv
 
\\Server-1\C$\Test\CopyData :Source file missing or The network path was not found.
Folder does not exist \\localhost\C$\Test\DestData
Error on creating directory \\localhost\C$\Test\DestData
Folder does not exist \\Home-PC\C$\Test\DestData
Error on creating directory \\Home-PC\C$\Test\DestData
 
.EXAMPLE
.\CopyPath.ps1 -InputFile Otherpathfile.csv -Verbose
 
.EXAMPLE
.\CopyPath.ps1 Importfile.csv -WhatIf -Verbose
This command doesn't make any changes but just tests it.
 
.EXAMPLE
get-help .\CopyPath.ps1
This is the way to get the help files
 
.EXAMPLE
PS Scripts&gt; .\CopyPath.ps1 -Verbose
 
VERBOSE: Source: \\Server-1\C$\Test\CopyData ;Destination: \\Server-1\C$\Test\DestData
\\Server-1\C$\Test\CopyData :Source file missing or The network path was not found.
VERBOSE: Source: C:\Test\CopyData ;Destination: \\localhost\C$\Test\DestData
Folder does not exist \\localhost\C$\Test\DestData
Error on creating directory \\localhost\C$\Test\DestData
VERBOSE: Source: C:\Test\CopyData ;Destination: \\Home-PC\C$\Test\DestData
Folder does not exist \\Home-PC\C$\Test\DestData
Error on creating directory \\Home-PC\C$\Test\DestData
 
.EXAMPLE
PS C:\test\scripts&gt; .\CopyPath.ps1
Copy Complete on: \\Server-1\C$\Test\DestData.
Copy Complete on: \\localhost\C$\Test\DestData.
Server not reachable: Home-PC
Server not reachable: Server1
</pre>
<div class="preview">
<pre class="powershell">.EXAMPLE&nbsp;
.\CopyPath.ps1&nbsp;
&nbsp;&nbsp;
.EXAMPLE&nbsp;
.\CopyPath.ps1&nbsp;<span class="powerShell__operator">-</span>InputFile&nbsp;Otherpathfile.csv&nbsp;
&nbsp;&nbsp;
\\Server<span class="powerShell__operator">-</span>1\C<span class="powerShell__variable">$</span>\Test\CopyData&nbsp;:Source&nbsp;file&nbsp;missing&nbsp;or&nbsp;The&nbsp;network&nbsp;path&nbsp;was&nbsp;not&nbsp;found.&nbsp;
Folder&nbsp;does&nbsp;not&nbsp;exist&nbsp;\\localhost\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
Error&nbsp;on&nbsp;creating&nbsp;directory&nbsp;\\localhost\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
Folder&nbsp;does&nbsp;not&nbsp;exist&nbsp;\\Home<span class="powerShell__operator">-</span>PC\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
Error&nbsp;on&nbsp;creating&nbsp;directory&nbsp;\\Home<span class="powerShell__operator">-</span>PC\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
&nbsp;&nbsp;
.EXAMPLE&nbsp;
.\CopyPath.ps1&nbsp;<span class="powerShell__operator">-</span>InputFile&nbsp;Otherpathfile.csv&nbsp;<span class="powerShell__operator">-</span>Verbose&nbsp;
&nbsp;&nbsp;
.EXAMPLE&nbsp;
.\CopyPath.ps1&nbsp;Importfile.csv&nbsp;<span class="powerShell__operator">-</span>WhatIf&nbsp;<span class="powerShell__operator">-</span>Verbose&nbsp;
This&nbsp;command&nbsp;doesn't&nbsp;make&nbsp;any&nbsp;changes&nbsp;but&nbsp;just&nbsp;tests&nbsp;it.&nbsp;
&nbsp;&nbsp;
.EXAMPLE&nbsp;
<span class="powerShell__cmdlets">get-help</span>&nbsp;.\CopyPath.ps1&nbsp;
This&nbsp;is&nbsp;the&nbsp;way&nbsp;to&nbsp;get&nbsp;the&nbsp;help&nbsp;files&nbsp;
&nbsp;&nbsp;
.EXAMPLE&nbsp;
<span class="powerShell__alias">PS</span>&nbsp;Scripts&gt;&nbsp;.\CopyPath.ps1&nbsp;<span class="powerShell__operator">-</span>Verbose&nbsp;
&nbsp;&nbsp;
VERBOSE:&nbsp;Source:&nbsp;\\Server<span class="powerShell__operator">-</span>1\C<span class="powerShell__variable">$</span>\Test\CopyData&nbsp;;Destination:&nbsp;\\Server<span class="powerShell__operator">-</span>1\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
\\Server<span class="powerShell__operator">-</span>1\C<span class="powerShell__variable">$</span>\Test\CopyData&nbsp;:Source&nbsp;file&nbsp;missing&nbsp;or&nbsp;The&nbsp;network&nbsp;path&nbsp;was&nbsp;not&nbsp;found.&nbsp;
VERBOSE:&nbsp;Source:&nbsp;C:\Test\CopyData&nbsp;;Destination:&nbsp;\\localhost\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
Folder&nbsp;does&nbsp;not&nbsp;exist&nbsp;\\localhost\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
Error&nbsp;on&nbsp;creating&nbsp;directory&nbsp;\\localhost\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
VERBOSE:&nbsp;Source:&nbsp;C:\Test\CopyData&nbsp;;Destination:&nbsp;\\Home<span class="powerShell__operator">-</span>PC\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
Folder&nbsp;does&nbsp;not&nbsp;exist&nbsp;\\Home<span class="powerShell__operator">-</span>PC\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
Error&nbsp;on&nbsp;creating&nbsp;directory&nbsp;\\Home<span class="powerShell__operator">-</span>PC\C<span class="powerShell__variable">$</span>\Test\DestData&nbsp;
&nbsp;&nbsp;
.EXAMPLE&nbsp;
<span class="powerShell__alias">PS</span>&nbsp;C:\test\scripts&gt;&nbsp;.\CopyPath.ps1&nbsp;
Copy&nbsp;Complete&nbsp;on:&nbsp;\\Server<span class="powerShell__operator">-</span>1\C<span class="powerShell__variable">$</span>\Test\DestData.&nbsp;
Copy&nbsp;Complete&nbsp;on:&nbsp;\\localhost\C<span class="powerShell__variable">$</span>\Test\DestData.&nbsp;
Server&nbsp;not&nbsp;reachable:&nbsp;Home<span class="powerShell__operator">-</span>PC&nbsp;
Server&nbsp;not&nbsp;reachable:&nbsp;Server1&nbsp;
</pre>
</div>
</div>
</div>
<div class="endscriptcode">&nbsp;NOTE:- This can be a function Copy-Path&nbsp;that can be dot sourced to the session if required, currently the function part is commented out to support direct script execution.</div>
