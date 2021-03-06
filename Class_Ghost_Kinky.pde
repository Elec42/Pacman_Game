/* Kinky */

class Kinky extends Ghost{

  int[] target = new int[2];
  int uP=0;
  boolean init=false;



  Kinky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Kinky", ghost_kinky_right0_img, ghost_kinky_right1_img, ghost_kinky_left0_img, ghost_kinky_left1_img, ghost_kinky_down0_img, ghost_kinky_down1_img, ghost_kinky_up0_img, ghost_kinky_up1_img, ghost_kinky_frightened_img, ghost_kinky_default_img, position, df);
  }

  void makeMove(int[] pacmanPosition, String pacmanDirection){

    if(super.isAlive){

      resetSmooth();
      uP++;
      if(!init|| (
        (pacmanDirection=="left"&&pacmanPosition[0]<=this.target[0]) ||
        (pacmanDirection=="right"&&pacmanPosition[0]>=this.target[0]) ||
        (pacmanDirection=="up"&& pacmanPosition[1]<=this.target[1]) ||
        (pacmanDirection=="down"&& pacmanPosition[1]>=this.target[1])
      ) || (this.target[0]==this.position[0]&&this.target[1]==this.position[1])) {
        uP=0;
        findTarget(pacmanPosition, pacmanDirection);
        init=true;
      }
      int[][] path = AStar(this.position, this.target, gameHandler.map, gameHandler.teleporters);

      if (path!=null) {
        int nPos[] = path[1].clone();

        if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
        else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

        if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
        else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}


        this.position = nPos.clone();
      }
    }
    else{
      if(super.deadCount>=super.deadTime){
        super.deadCount = 0;
        super.isAlive = true;
      }
      else
        super.deadCount++;
    }
  }

  void findTarget(int[] pacmanPosition, String pacmanDirection) {
    int sPos[] = pacmanPosition.clone();

    boolean loop = true;
    int directionVector[] = new int[2];

    switch(pacmanDirection) {
      case "up": directionVector[1]=-1;break;
      case "down": directionVector[1]=1;break;
      case "left": directionVector[0]=-1;break;
      case "right": directionVector[0]=1;break;
      default : this.target = pacmanPosition; return;
    }

    String nextDirection=pacmanDirection;
    int foundNumber=0;
    do {
      if(foundNumber!=0&&foundNumber<2) {
        switch(nextDirection) {
          case "up": directionVector[1]=-1;directionVector[0]=0;break;
          case "down": directionVector[1]=1;directionVector[0]=0;break;
          case "left": directionVector[0]=-1;directionVector[1]=0;break;
          case "right": directionVector[0]=1;directionVector[1]=0;break;
          default : break;
        }
      }
      else if(foundNumber>=2) {
        loop=false;
        continue;
      }
      foundNumber=0;

      sPos[0]+=directionVector[0];
      sPos[1]+=directionVector[1];
      sPos[0] %= gameHandler.map[0].length;
      sPos[1] %= gameHandler.map.length;
      sPos[0] = sPos[0]<0?gameHandler.map[0].length-1:sPos[0];
      sPos[1] = sPos[1]<0?gameHandler.map.length-1:sPos[1];

      if(sPos[0]==this.position[0]&&sPos[1]==this.position[1]) {
        loop = false;
        sPos = pacmanPosition.clone();
        continue;
      }
      else if(gameHandler.map[sPos[1]][sPos[0]]==1) {
        sPos[0]-=directionVector[0];
        sPos[1]-=directionVector[1];
        sPos[0] %= gameHandler.map[0].length;
        sPos[1] %= gameHandler.map.length;
        sPos[0] = sPos[0]<0?gameHandler.map[0].length-1:sPos[0];
        sPos[1] = sPos[1]<0?gameHandler.map.length-1:sPos[1];
        loop=false;
        continue;
      }
      else {
        switch(nextDirection) {
          case "up":
            if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1){nextDirection="up";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1){nextDirection="left";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){nextDirection="right";foundNumber++;}
            break;

          case "down":
            if(gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){nextDirection="down";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1){nextDirection="left";foundNumber++;}
            if(gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){nextDirection="right";foundNumber++;}
            break;

          case "left":
            if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1){nextDirection="left";foundNumber++;}
            if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1){nextDirection="up";foundNumber++;}
            if(gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){nextDirection="down";foundNumber++;}
            break;

          case "right":
            if(gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){nextDirection="right";foundNumber++;}
            if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1){nextDirection="up";foundNumber++;}
            if(gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){nextDirection="down";foundNumber++;}
            break;
        }
      }
    }while(loop);
    this.target=sPos.clone();
  }

}
