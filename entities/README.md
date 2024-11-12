# Notes on entities and their layers:
	
Players + Enemies can walk through each other
Nothing can walk though Walls 


Player: 
	- It's layer: Player
	- Its mask: walls 
	- its' detection-area collider: 
		- Enemy (used to see if Player close enough to attack enemy)
		- Bullet (used to see if player to take damage from bullet)
		- Goal (used to see if player has reached the goal)
	
Enemy:
	- Its layer: Enemy
	- Its mask: walls 
