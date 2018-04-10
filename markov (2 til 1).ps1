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
		$Starters = $listdata | ForEach-Object {$_.split(" ")[0] + " " + $_.split(" ")[1]}

		#DB creation
		$DB = @()
		foreach ($data in $listdata){
			$words = $data.Split(" ")
			$counter = 0

			for ($i = 0; $i -lt $words.Count; $i++) {
				if($words[$i + 1] -match "(\.$)|(^$)" ){
					
				} else{

					$Lookup = $words[$i] + " " + $words[$i + 1]
					$Follow = $words[$i + 2]
					
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

		#markovLogic
		$CurrentWord = $Starters | Get-Random
		$splittedOutput += $CurrentWord.trim().split(" ") 

		$count = 1
		while ($CurrentWord -notmatch "(\.$)|(^$)" -and $count -lt 100) {
			$PossibleWords = ($DB.where({$_.Lookup -eq "$($splittedOutput[-2]) $($splittedOutput[-1])"})) 
			$CurrentWord = ($PossibleWords | get-random).Follow
			$splittedOutput += $CurrentWord
			$count++
		}
		$Output = $splittedOutput -join " "
		$Output
		
	}
	
	end {
	}
}