on run
	--Get the disk
	-- get a list of items in the Volumes folder (basically a list of mounted disks)
	do shell script "ls /Volumes/"
	-- set _Result to the list items
	set _Result to the paragraphs of result
	-- set theVolumeTemp to choose a volume from the list, result would be something like "Macintosh HD"
	set theVolumeTemp to (choose from list _Result with prompt "Choose Volume:" without empty selection allowed) as string
	-- if user presses Cancel, close the dialog
	if theVolumeTemp is false then return
	-- set theVolume to the actual path, e.g. /Volumes/Macintosh HD/
	
	--Ask user for the name of the folder
	display dialog "New Folder Name" default answer "TEMP"
	set myFolder to text returned of result
	
	--Create folder at Desktop
	set logpath to (path to desktop from user domain) as string
	set logfolder to logpath & myFolder
	tell application "Finder"
		if not (exists folder logfolder) then
			make new folder at folder logpath with properties {name:myFolder}
		end if
	end tell
	
	--Get the folder
	set theFolder to theVolumeTemp & ":System:Library:Extensions:"
	--set theFolder to (choose folder with prompt "Select the folder that contains the files to copy. In the next step you'll be able to select the files to copy.") as text
	
	--Generate the list of files inside theFolder
	tell application "Finder"
		set theItems to items of folder theFolder
		set theNames to {}
		repeat with anItem in theItems
			set end of theNames to name of anItem
		end repeat
	end tell
	
	--Let user select the files of the list
	choose from list theNames with prompt "Select the files" OK button name "OK" cancel button name "Cancel" with multiple selections allowed
	
	tell result
		if it is false then error number -128 -- cancel
		set theChoices to it
	end tell
	
	if (count of theChoices) is greater than or equal to 1 then
		repeat with aChoice in theChoices
			set thisItem to (theFolder & aChoice) as alias
			-- do something with thisItem
			tell application "Finder" to duplicate thisItem to logfolder
		end repeat
	end if
end run