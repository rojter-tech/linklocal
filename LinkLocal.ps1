function MigrateFile {
    [CmdletBinding()]
    param(
        $source,
        $target
    )

	$isjunction=((Get-Item $source).LinkType -eq "Junction")
	$issymbolic=((Get-Item $source).LinkType -eq "SymbolicLink")
	$ishardlink=((Get-Item $source).LinkType -eq "HardLink")
	
	if ((-not $isjunction) -and (-not $issymbolic) -and (-not $ishardlink)) {
		echo "Migrating $source to $target"
		if ((Test-Path $source) -and (-not (Test-Path $target))) {
			Move-Item $source $target
			New-Item -ItemType Junction -Path $source -Target $target
		}
		else {
			echo "Source or target already exist."
		}
		
	} else {
		if (-not (Test-Path $target)) {
			mkdir $target
		}
		if ($isjunction) {
			echo "$source is allready a junction, no new link neccesary"
		}elseif ($issymbolic) {
			echo "$source is allready a symbolic link, no new link neccesary"
		}elseif ($ishardlink) {
			echo "$source is allready a hardlink, no new link neccesary"
		}else {
			echo "this message should not be echoed to the console"
		}
	}
}

function LinkLocal {
    [CmdletBinding()]
    param(
		$directory
    )
	
	$pathway=":\Users\$env:UserName"
	$source="C$pathway\$directory"
	$target="D$pathway\$directory"
	if (-not (Test-Path D$pathway)) {
		mkdir "D$pathway"
	}
	
	$sourceexists=(Test-Path $source)
	$targetexists=(Test-Path $target)
	if ($sourceexists) {
		$sourceisdir=((Get-Item $source) -is [System.IO.DirectoryInfo])
	}else {
		$sourceisdir="True"
	}
	
	if ($sourceisdir) {
	
		if ($sourceexists) {
			MigrateFile $source $target
		}else {
			if ((-not $targetexists)) {
					mkdir $target
			}
			New-Item -ItemType Junction -Path $source -Target $target
		}
	
	}else {
		echo "$source is not a directory"
	}
}

