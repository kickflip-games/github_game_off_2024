# Leaderboard:
	
Using silentwolf
The API keys etc are already setup.

```
	# savinng scores
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
  print("Score persisted successfully: " + str(sw_result.score_id))
  var position = sw_result.position # get position of player in leaderboard


 	# get all scores
	  var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	print("All scores: " + str(sw_result.scores))


	# find position in leaderboard wuthout posting anything
	SilentWolf.Scores.get_score_position(score)
	
	
	# wiping leaderboard
	  SilentWolf.Scores.wipe_leaderboard(ldboard_name)
```
