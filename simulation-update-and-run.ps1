# set working directory to the location of this script
Set-Location -Path $PSScriptRoot


$simulation_license_file = "./tools/simulation_license.json"
$input_modules_and_table_excel_file = "./input/modules_and_tables.xlsx"
$input_modules_and_table_jsonl_file = "./input/modules_and_tables.jsonl"
$ledger_transactions_jsonl_file = "./input/ledger_transactions_json_file.jsonl"
$reports_jsonl_file = "./input/ledger_transactions_json_file.jsonl"
$input_reportssettings_file = "./input/reports_settings.xlsx"
$reports_output_folder = "./output"

#region functions
function test-and-update-deno {
    $last_working_deno_ver = "1.11.3"
    $running_deno_ver = -split (./tools/bin/deno --version | select-string -Pattern 'deno') | Select -Index 1 

    if (!$?) {
        # deno is not installed, or there were problems detecting the version
        $v=$last_working_deno_ver  # set the version of Deno to install
        $env:DENO_INSTALL = $PSScriptRoot + "/tools"  # set the path of Deno to install
        Write-Output "Deno missing, installing..."
        Invoke-WebRequest https://deno.land/x/install/install.ps1 -UseBasicParsing | Invoke-Expression
    }  
    elseif ([version]$running_deno_ver -lt [version]$last_working_deno_ver) {
        Remove-Item ./tools/bin/deno.exe
        $v=$last_working_deno_ver  # set the version of Deno to install
        $env:DENO_INSTALL = $PSScriptRoot + "/tools"  # set the path of Deno to install
        Write-Output "Deno is too old, installing the right version..."
        Invoke-WebRequest https://deno.land/x/install/install.ps1 -UseBasicParsing | Invoke-Expression
    }
}

function test-and-update-simulationpackage {

    $last_working_simulationpackage_ver = "0.0.1"

    #TODO
    <#
    take part of the code from
    https://deno.land/x/install@v0.1.4/install.ps1

    to download from somewhere (Azure?)

    a zip file with:
    * simulation-package-version.txt
    * bin/Program.exe
    * bin/Convert.exe
    * SimulationSampleSheet.xls
    * main.js
    * ...whatelse...

    script updating logic:
    * compare the content of the variable `$last_working_simulationpackage_ver` with the content of the file `simulation-package-version.txt`
    * if the file `simulation-package-version.txt` is older
      * delete all the files listed above
      * download the new zip and unzip it insise the `tools` folder
    #>

}

function run-convert-excel-modules-and-tables-to-json {

    #TODO
    <#
    Call convert.exe with parameter:
    --input $input_modules_and_table_excel_file
    --output $input_modules_and_table_jsonl_file
    #>
}

function run-main-js {

    #TODO
    <#
    Call main.js with parameter:
    --input $input_modules_and_table_jsonl_file
    --output $ledger_transactions_jsonl_file
    #>
}

function run-simulation {

    #TODO
    <#
    call simulation.exe with parameter:
    --license $simulation_license_file
    --settings $input_reportssettings_file
    --input $input_modules_and_table_jsonl_file
    #>
}

function run-convert-reports-jsonl-to-excel {

    #TODO
    <#
    Call convert.exe with parameter:
    --input $reports_jsonl_file
    --output $reports_output_folder
    #>
}


Execute Convert with parameter:
* —output pointing to /output folder

#endregion functions

test-and-update-deno

test-and-update-simulationpackage

run-convert-excel-modules-and-tables-to-json

run-main-js

run-simulation

run-convert-reports-jsonl-to-excel


# do other actions
Write-Output "do other actions..."


############### EXTRA CODE ONLY TO TEST

$fileA = ".\temp.txt"  # slash or backslash is the same
$fileB = "./temp2.txt"  # slash or backslash is the same
$successFile = "./ps1.success.txt"
$errorFile = "./ps1.error.txt"

Remove-Item $fileA -ErrorAction Ignore
Remove-Item $fileB -ErrorAction Ignore
Remove-Item $successFile -ErrorAction Ignore
Remove-Item $errorFile -ErrorAction Ignore

Set-Content -Path $fileA -Value 'Hello, World'  # create $fileA and put some text inside
Add-Content -Path $fileA -Value 'Hello, World 2'  # append text to $fileA

./tools/bin/deno run --allow-read --allow-write https://raw.githubusercontent.com/stefano77it/financial-modeling/master/temp-test-code/v1/zTempSomeCodeOnlyToTestACallToRemoteDenoCode.ts -i $fileA -o $fileB

if ((Get-FileHash $fileA).hash -eq (Get-FileHash $fileB).hash) {
    Write-Output "execution ended successfully"
    Set-Content -Path $successFile -Value 'success'
}
else {
    Write-Output "execution ended in error"
    Set-Content -Path $errorFile -Value 'error'
}

# remove `$errorFile` if empty
if (Test-Path $errorFile)
    {
        if ((Get-Item $errorFile).length -eq 0) { Remove-Item $errorFile -ErrorAction Ignore }
    }

# Read-Host -Prompt "execution ended, press RETURN to continue";
