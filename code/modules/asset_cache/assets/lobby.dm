/datum/asset/simple/icon_states/lobby
	icon = 'icons/lobby/icon.dmi'
	prefix = FALSE

/datum/asset/simple/lobby_art/register()
	var/asset = icon('icons/lobby/title.dmi', SSlobby_art.selected_file_name)
	if(!asset)
		return

	asset = fcopy_rsc(asset) //dedupe

	SSassets.transport.register_asset("lobby_art.png", asset)
	assets["lobby_art.png"] = asset

/datum/asset/simple/lobby_files
	keep_local_name = TRUE
	assets = list(
		"load.mp3" = 'sound/machines/tcomms_on.ogg',
	)

/datum/asset/simple/restart_animation
	assets = list(
		"loading" = 'html/lobby/loading.gif'
	)
