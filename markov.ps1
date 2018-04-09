

#Start markov

function Get-MarkovSentence {
	[CmdletBinding()]
	param (
		$DataPath = "C:\Programering\Powershell\markov\wordlist.txt"
	)
	
	begin {
	}
	
	process {

		$listdata = get-content -Path $DataPath -Encoding UTF8

		#split wordlist til et forståelig object
		$Starters = $listdata | foreach {$_.split(" ")[0]}
		$DB = @()
		foreach ($data in $listdata){
			$words = $data.Split(" ")
			$counter = 0

			for ($i = 0; $i -lt $words.Count; $i++) {
				if($words[$i] -match "(\.$)|(^$)" ){
					
				} else{

					$Lookup = $words[$i] 
					$Follow = $words[$i + 1]
					
					$Exsistingline = $DB.where({$_.Lookup -eq $Lookup -and $_.Follow -eq $Follow})

					if($Exsistingline){
						$index = $DB.IndexOf($Exsistingline)
						$DB[$index].rating += 1
					}else{
						$DB += [pscustomobject]@{
							Lookup = $Lookup
							Follow = $Follow
							rating = 1
						}
					}
				}
			}
		}

		
		$CurrentWord = $Starters | Get-Random

		$output = "$CurrentWord "

		$count = 1
		while ($CurrentWord -notmatch "(\.$)|(^$)" -and $count -lt 100) {
			$CurrentWord = (($DB.where({$_.Lookup -eq $CurrentWord})) | get-random).Follow
			$output += "$CurrentWord "
			$count++
		}
		$Output
		
	}
	
	end {
	}
}

#$startWords = ($listdata | Get-Random).split(" ") | select -first 2

#$nextword = (($listdata | where {($_.split(" ")) -eq $startWords[1]} | get-random).split(" ")).indexof("$startWords[1]")