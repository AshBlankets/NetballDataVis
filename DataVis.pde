ArrayList<Team> teams;
ArrayList<Year> years;
ArrayList<GameArc> gm;
GameArc currentGM;
DrawData dd;
FilterMenu fm;
Year active;
int yr;
Team activeTeam;
String activeCountry;
String fillBy;
String strokeBy;
String seasonBy;
int arcSize;
boolean mustDraw;
void setup() {
  size(1280, 720);
  background(230);
  yr=0;
  rectMode(CORNER);
  ellipseMode(CENTER);
  textSize(50);
  teams = new ArrayList<Team>();
  years = new ArrayList<Year>();
  gm = new ArrayList<GameArc>();
  loadDataVis();
  dd = new DrawData();
  fm = new FilterMenu();
  mustDraw=true;
  fillBy = "year";
  strokeBy = "country";
  seasonBy="season and finals";
  arcSize=10;
}
void draw() {
  if (mustDraw) {
    background(230);
    if(mousePressed){
    if(mouseX>100&&mouseX<1100&&mouseY>180&&mouseY<680){
  checkOnGame(mouseX,mouseY);
  }}
    dd.drawData(mouseX, mouseY);
    if(currentGM!=null)currentGM.drawGameArc();
    
    mustDraw=false;
  }
}

void mousePressed() {
  dd.pressed(mouseX, mouseY);
  
  mustDraw=true;
}

void populateYr() {
  active = years.get(yr-2008);
}
void checkOnGame(float x, float y){
  for(int i =gm.size()-1;i>=0;i--){
    if(gm.get(i).checkOn(x,y))currentGM=gm.get(i);
  }
}

//===========================================================
// drawing methods
//===========================================================

class YAxis {
  float x;
  float y;
  float ht;
  int mode; //0=total score 1=home score 2=away score
  public YAxis(float x, float y, float ht) {
    this.x=x;
    this.y=y;
    this.ht=ht;
    mode = 0;
  }

  void drawYAxis() {
    fill(0);
    line(x, y, x, y+ht);
    if(mode==0){
      int j=0;
      int k = ht/12;
    for(int i =40;i<170;i+=10){
      fill(0);
      line(x-4,y+ht-j, x, y+ht-j);
      textSize(10);
      text(i,x-20,y+ht-j);
      j+=k;
    }
  }
  else{
    int j=0;
      int k = ht/16;
    for(int i =0;i<85;i+=5){
      fill(0);
      line(x-4,y+ht-j, x, y+ht-j);
      textSize(10);
      text(i,x-20,y+ht-j);
      j+=k;
    }
  }
  stroke(170);
  switch(mode){
case 0: fill(200);
rect(x-90, y+110,60,20);
break;
case 1:fill(200);
rect(x-90, y+10,60,20);
break;
case 2:fill(200);
rect(x-90, y+60,60,20);
break;
  }
  fill(0);
  text("home score", x-60, y+20);
  text("away score",x-60, y+70);
  text("total score",x-60, y+120);
  }

  float getY(Game g) {
    switch (mode) {
    case 0 :
      return y+ht-(map(g.getHomeScore()+g.getAwayScore(), 40, 160, 0, ht));
      //return mapped by totalscore
    case 1 :
      return y+ht-(map(g.getHomeScore(), 0, 80, 0, ht));
      //return mapped by home score
    case 2 :
      return y+ht-(map(g.getAwayScore(), 0, 80, 0, ht));
      //return mapped by home score
    }
    return 0;
  }

  void setMode(float xm,float ym){
    if(xm>x-90&&xm<x-90+60){
if(ym> y+110&&ym<y+110+20){
  mode=0;}
else if(ym>y+10 &&ym<y+10+20){
  mode = 1;
  
}
else if(ym>y+60 &&ym<y+60+20){
mode=2;
}
  }
}
}


class DrawData {
  int startY;
  int ht;
  YAxis ya;

  public DrawData() {
    startY = 180;
    ht = 500;
    ya = new YAxis(100, 180, 500);
  }

  void pressed(float x, float y) {
    fm.checkPressed(x, y);
    ya.setMode(x,y);
  }


  void drawData(float x, float y) {
    fm.drawFilterMenu();
    if(seasonBy.equals("season and finals")){
      for (int i = 0;i<17;i++) {
       fill(200);
       noStroke();
       if (i%2==0)rect(100+i*53, startY, 53, ht);
       fill(0);
       textSize(10);
       text(i+1, 100+i*53+53/2, height-25);
      }
    }
    else if(seasonBy.equals("season")){
      for (int i = 0;i<14;i++) {
       fill(200);
       noStroke();
       if (i%2==0)rect(100+i*64, startY, 64, ht);
       fill(0);
       textSize(10);
      text(i+1, 100+i*64+64/2, height-20);

      }
    }
    else if(seasonBy.equals("finals")){
      for (int i = 0;i<3;i++) {
       fill(200);
       noStroke();
       if (i%2==0)rect(100+i*300, startY, 300, ht);
       fill(0);
       textSize(10);
       text(i+1, 100+i*300+300/2, height-20);

      }
    }
    fill(0);
    textSize(15);
    text("round",975,height-8);
    strokeWeight(2);
    stroke(0);
    line(100, startY+ht, 1000, startY+ht);
    ya.drawYAxis();
    gm = new ArrayList<GameArc>();
   // int i=0; //I dont know why this was here

   //ALL WIDTHS 43 ATM.....CHANING O_O
    if (active==null) {
      if(seasonBy.equals("season and finals")){
      for (Year yy: years) {
        for (Round r: yy.getRounds()) {
          drawRound(r, 110, startY, 43, ht);
         // i++;//I dont know why this was here
        }
      }
    }
    else if(seasonBy.equals("season")){
    for (Year yy: years) {
      int i =0;
      roundLoop:
        for (Round r: yy.getRounds()) {
          drawRound(r, 110, startY, 54, ht);
          i++;
          if(i==14)break roundLoop;
           //I dont know why this was here
        }
      }
    }
    else if(seasonBy.equals("finals")){
    for (Year yy: years) {
        for (int i=14;i<yy.getRounds().size();i++) {
          drawRound(yy.getRounds().get(i), -4000, startY, 290, ht);
          //i++;//I dont know why this was here
        }
      }
    }
  }
    else {
      if(seasonBy.equals("season and finals")){
        for (Round r: active.getRounds()) {
          drawRound(r, 110, startY, 43, ht);
         // i++;//I dont know why this was here
        }
      
    }
    else if(seasonBy.equals("season")){
      int i =0;
      roundLoop:
        for (Round r: active.getRounds()) {
          drawRound(r, 110, startY, 54, ht);
          i++;
          if(i==14)break roundLoop;
           //I dont know why this was here
        }
      
    }
    else if(seasonBy.equals("finals")){
        for (int i=14;i<active.getRounds().size();i++) {
          drawRound(active.getRounds().get(i), -4000, startY, 290, ht);
          //i++;//I dont know why this was here
        }
      }





    }
  }

  void drawRound(Round r, float x, float y, float wd, float ht) {

    float startX = x+(wd+10)*(r.getRoundNum()-1); //start of the rounds
    fill(0);
    textSize(10);
   // text(r.getRoundNum(), startX+wd/2, height-20);

    int i = 0;

    //making new objects so don't have to keep calling methods
    ArrayList<Game> holdR = r.getGames();
    int sz = holdR.size();

    for (Game g: holdR) {
      //check that we can draw the game

if((activeTeam==null ||g.getHome()==activeTeam||g.getAway()==activeTeam)&&
  (activeCountry==null||g.getHome().getCountry().equals(activeCountry)||g.getAway().getCountry().equals(activeCountry))){
      
      col c1 = fm.getFill(g, g.getHome());
      col c2 = fm.getStroke(g, g.getHome());
      fill(c1.r, c1.g, c1.b);
      stroke(c2.r, c2.g, c2.b);
      float yValue = ya.getY(g);
      arc(startX+i*wd/sz, yValue, 10, 10, PI, TWO_PI);

      c1 = fm.getFill(g, g.getAway());
      c2 = fm.getStroke(g, g.getAway());
      fill(c1.r, c1.g, c1.b);
      stroke(c2.r, c2.g, c2.b);
      arc(startX+i*wd/sz, yValue, 10, 10, 0, PI);
      gm.add(new GameArc(startX+i*wd/sz, yValue, 11,g));

      i++;
    }
  }
  }
}











//===========================================================
// FILTER MENU CLASSES
//===========================================================


class FilterMenu {
  boolean down;//whether the filter menu is down
  YearFilter yf;
  TeamFilter tf;
  CountryFilter cf;
  FinalFilter ff;

  Filters filters;
  FillKey fk;
  StrokeKey sk;
  ArrayList<FilterColor> fc;
  int currentFilter;
  int currentColorButton;

  //boolean drop;//whether it's moving
  public FilterMenu() {
    down = false;
    currentFilter=-1;
    currentColorButton=-1;
    yf = new YearFilter();
    tf = new TeamFilter();
    cf = new CountryFilter();
    ff = new FinalFilter();
    filters = new Filters();//holds the current state of the filters
    fk = new FillKey(width-250,420,40,8);
    sk = new StrokeKey(width-120,425,30,18);
    fc = new ArrayList<FilterColor>();
    fc.add(new FilterColor(685));
    fc.add(new FilterColor(835));
    fc.add(new FilterColor(985));
    fc.add(new FilterColor(985));

    //  drop = false;
  }
  void drawFilterMenu() {
    fill(0);
    noStroke();
    rect(0, 0, width, 70);
    drawMenuButtons();
    if (down) {
      fill(100);
      rect(0, 70, width, 70);
      if (currentFilter==0) {
        yf.drawYearFilter();
      }
      else if (currentFilter==1) {
        tf.drawTeamFilter();
      }
      else if (currentFilter==2) {
        cf.drawCountryFilter();
      }
      else if (currentFilter==3) {
        ff.drawFinalFilter();
      }
      if (currentColorButton==0) {
        fc.get(0).drawFilterColor();
      }
      else if (currentColorButton==1) {
        fc.get(1).drawFilterColor();
      }
      else if (currentColorButton==2) {
        fc.get(2).drawFilterColor();
      }
      else if (currentColorButton==3) {
        fc.get(3).drawFilterColor();
      }
    }
    else {
      fill(0);
      textSize(18);
      text("filter by", 80, 90);
      text("colour by", width-100, 90);
    }
    fill(0);
    textSize(20);
    text(filters.getFilters(), width/2, 160);
    drawHome(width-60, 20, 30);
    fk.drawFillKey();
    sk.drawStrokeKey();
  }

  void drawHome(float x, float y, float wd) {
    noStroke();
    fill(40, 200, 220);
    rect(x, y, wd, wd);
    fill(255, 255, 255);
    rect(x+wd/4, y+wd/2, wd/2, wd/3);
    triangle(x+wd/12, y+wd/2, x+wd/2, y+wd/6, x+11*wd/12, y+wd/2);
  }

  col getFill(Game g, Team t) {
    //TODO dot equals? not ==
  if(fillBy.equals("country")){
    if (t.getCountry().equals("New Zealand")) {
      return new col(30, 150, 255);
    }
    else { 
      return new col(199, 21, 133);
    }
  }
  else if(fillBy.equals("team")){
    return t.getColor();
  }
  else if(fillBy.equals("year")){
    //TODO: fill by year
    if(g.getYear()==2008){
        return new col(255,255,255);
      }
      else if(g.getYear()==2009){
        return new col(150,150,150);
       }
      else if(g.getYear()==2010){
        return new col(102,200,255);
      }
      else if(g.getYear()==2011){
        return new col(0,90,140);
      }
      else if(g.getYear()==2012){
        return new col(0,0,102);
      }
      else if(g.getYear()==2013){
        return new col(0,0,0);
      }
  }
  else if(fillBy.equals("home")){
    if (g.getHome()==t) {
      return new col(30, 50, 155);
    }
    else {
      return new col(120, 21, 70);
    }
  }
  return new col(255,0,0);
  }

  col getStroke(Game g, Team t) {
    if(strokeBy.equals("country")){
      if (t.getCountry().equals("New Zealand")) {
      return new col(30, 150, 255);
    }
    else { 
      return new col(199, 21, 133);
    }
    }
    else if(strokeBy.equals("team")){
    return t.getColor();
    }
    else if(strokeBy.equals("year")){
      //TODO: stroke by year
      if(g.getYear()==2008){
        return new col(255,255,255);
      }
      else if(g.getYear()==2009){
        return new col(150,150,150);
       }
      else if(g.getYear()==2010){
        return new col(102,200,255);
      }
      else if(g.getYear()==2011){
        return new col(0,90,140);
      }
      else if(g.getYear()==2012){
        return new col(0,0,102);
      }
      else if(g.getYear()==2013){
        return new col(0,0,0);
      }
    }
    else if(strokeBy.equals("home")){
    if (g.getHome()==t) {
      return new col(30, 50, 155);
    }
    else {
      return new col(120, 21, 70);
    }
  }
  return new col(255,0,0);
  }
  void drawMenuButtons() {
    fill(180);
    float startX = 20;
    float startY = 10;
    float wd = 130;
    float ht = 50;
    for (int i=0;i<5;i++) {
      rect(startX*i+wd*(i-1), startY, wd, ht);
    }
    for (int i=5;i<9;i++) {
      fill(40, 200, 220);
      rect(startX*i+wd*(i-1), startY, wd, ht);
    }
    fill(0);
    textSize(25);
    textAlign(CENTER);
    text("season", startX+wd/2, startY+70/2);
    text("team", startX*2+3*wd/2, startY+70/2);
    text("country", startX*3+5*wd/2, startY+70/2);

    text("season", startX*5+9*wd/2, startY+70/2);
    text("team", startX*6+11*wd/2, startY+70/2);
    text("country", startX*7+13*wd/2, startY+70/2);
    text("home/away", startX*8+15*wd/2, startY+70/2);
    textSize(22);
    text("season/finals", startX*4+7*wd/2, startY+70/2);
  }



  void checkPressed(float x, float y) {
    if (y<60&&y>10) {
      down=true;
      if (x>20&&x<150) {
        currentFilter=0;
        currentColorButton=-1;
      }//season
      else if (x>170&&x<300) {
        currentFilter=1;
        currentColorButton=-1;
      }//team
      else if (x>320&&x<450) {
        currentFilter=2;
        currentColorButton=-1;
      }//country
      else if (x>470&&x<600) {
        currentFilter=3;
        currentColorButton=-1;
      }//home away


      if (x>620&&x<750) {
        currentColorButton=0;
        currentFilter=-1;
      }//season
      else if (x>770&&x<900) {
        currentColorButton=1;
        currentFilter=-1;
      }//team
      else if (x>920&&x<1050) {
        currentColorButton=2;
        currentFilter=-1;
      }//country
      else if (x>1070&&x<1200) {
        currentColorButton=3;
        currentFilter=-1;
      }//home away
      else if (x>width-60&&x<width-30) {
        //TODO: RESET THE FILTERSSSS
        yr=0;
        active=null;
        activeTeam=null;
        activeCountry=null;
        fillBy="year";
        strokeBy="country";
        seasonBy="season and finals"
      }
    }
    else if (y>80&&y<130) {
      switch (currentFilter) {   
      case 0:
        if (x>20&&x<150) {
          yr=2008;
          populateYr();
        }
        else if (x>170&&x<300) {
          yr=2009;
          populateYr();
        }
        else if (x>320&&x<450) {
          yr=2010;
          populateYr();
        }
        else if (x>470&&x<600) {
          yr=2011;
          populateYr();
        }
        else if (x>620&&x<750) {
          yr=2012;
          populateYr();
        }
        else if (x>770&&x<900) {
          yr=2013;
          populateYr();
        }  
        else if (x>920&&x<1050) {
          yr=0;
          active=null;
        }  
        break;
      case 1 : //changing the team
        int wd = 104;
        int startX = 10;
        int i=1;
        for (Team t: teams) {
          if (x>startX*i+wd*(i-1)&&x<startX*i+wd*(i-1)+wd) {
            activeTeam = t;
            break;
          }
          i++;
        }
        if(x>1150&&x<1254) activeTeam=null;
        break;  

        case 2 ://changing the country
          int startX = 320;
          int wd = 130;
          for(int i=0;i<3;i++){
            if(x>startX+i*(wd+20)&&x<startX+i*(wd+20)+wd){
              if(i==0){activeCountry="New Zealand";break;}
              if(i==1){activeCountry="Australia";break;}
              if(i==2){activeCountry=null;break;}
            }
          }
        break;
        case 3:
        int startX=470;
        int wd = 130;
        for(int i=0;i<3;i++){
            if(x>startX+i*(wd+20)&&x<startX+i*(wd+20)+wd){
              if(i==0){seasonBy="season";break;}
              if(i==1){seasonBy="finals";break;}
              if(i==2){seasonBy="season and finals";break;}
            }
          }
        break;
      }

      if(currentColorButton>=0){
        int i = fc.get(currentColorButton).on(x);
        if(i==0){
        switch (currentColorButton){
                case 0 :
                 fillBy = "year";
                break; 
                case 1 :
                 fillBy = "team";
                break; 
                case 2 :
                 fillBy = "country";
                break; 
                case 3 :
                 fillBy = "home";
                break;     
              }
        }
        else if(i==1){
                  switch (currentColorButton){
                case 0 :
                 strokeBy = "year";
                break; 
                case 1 :
                 strokeBy = "team";
                break; 
                case 2 :
                 strokeBy = "country";
                break; 
                case 3 :
                 strokeBy = "home";
                break;     
              }
        }  
      }     
    }
    else if (y>140) {
      down=false;
    }
   // println("down:"+down+" colourbutton:"+currentColorButton+" fill by:"+fillBy+" strokeby: "+strokeBy);
  }
}
class FillKey{
  float x;
  float y;
  float wd;
  float gap;
public FillKey(float x, float y, float wd, float gap){
this.x=x;
this.y=y;
this.wd=wd;
this.gap=gap;
}

void drawFillKey(){
noStroke();
if(fillBy.equals("country")){
  fill(30, 150, 255);
  rect(x, y, wd, wd);
  fill(199, 21, 133);
  rect(x, y+gap+wd, wd, wd);
  fill(0,0,0);
  textSize(25);
  text("NZ",x+wd/2,y+wd/2);
  text("AU",x+wd/2,y+gap+wd+wd/2);

}
else if(fillBy.equals("home")){
  fill(30, 50, 155);
  rect(x, y, wd, wd);
  fill(120, 21, 70);
  rect(x, y+gap+wd, wd, wd);
  fill(255,255,255);
  textSize(15);
  text("home",x+wd/2,y+wd/2);
  text("away",x+wd/2,y+gap+wd+wd/2);

}
else if(fillBy.equals("team")){
//TODO
textSize(18);
int i = 0;
for(Team t: teams){
  if(i<5){
        fill(t.getColor().r,t.getColor().g,t.getColor().b);
        rect(x, y+i*gap+i*wd, wd, wd);
        fill(0,0,0);
        text(t.getShortName(),x+wd/2, y+i*gap+i*wd+wd/2);
        i++;
        }
        else{
        fill(t.getColor().r,t.getColor().g,t.getColor().b);
        rect(x+wd+gap, y+(i-5)*gap+(i-5)*wd, wd, wd);
        fill(0,0,0);
        text(t.getShortName(),x+wd/2+wd+gap, y+(i-5)*gap+(i-5)*wd+wd/2);
        i++;
        }
}
}
else if(fillBy.equals("year")){
  int i =0;
textSize(18);
//2008
        fill(255,255,255);
        rect(x, y+i*gap+i*wd, wd, wd);
        fill(0,0,0);
        text("2008",x+wd/2, y+i*gap+i*wd+wd/2);

        i++;

 //2009
        fill(150,150,150);
      rect(x, y+i*gap+i*wd, wd, wd);
      fill(0,0,0);
        text("2009",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
//2010
        fill(102,200,255);
       rect(x, y+i*gap+i*wd, wd, wd);
       fill(0,0,0);
        text("2010",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
 //2011
     fill(0,90,140);
     rect(x, y+i*gap+i*wd, wd, wd);
     fill(255,255,255);
        text("2011",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
//2012
       fill(0,0,102);
       rect(x, y+i*gap+i*wd, wd, wd);
       fill(255,255,255);
        text("2012",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
 //2013
        fill(0,0,0);
        rect(x, y+i*gap+i*wd, wd, wd);
        fill(255,255,255);
        text("2013",x+wd/2, y+i*gap+i*wd+wd/2);
i=0;

}
}

}

class StrokeKey{
  float x;
  float y;
  float wd;
  float gap;
  public StrokeKey(float x, float y, float wd, float gap){
this.x=x;
this.y=y;
this.wd=wd;
this.gap=gap;
  }
  void drawStrokeKey(){
noFill();
strokeWeight(10);
if(strokeBy.equals("year")){
  int i=0;
  textSize(18);
//2008
 noFill();

        stroke(255,255,255);
        rect(x, y+i*gap+i*wd, wd, wd);
        fill(0,0,0);
        text("2008",x+wd/2, y+i*gap+i*wd+wd/2);

        i++;

 //2009
  noFill();

        stroke(150,150,150);
      rect(x, y+i*gap+i*wd, wd, wd);
      fill(0,0,0);
        text("2009",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
//2010
 noFill();

        stroke(102,200,255);
       rect(x, y+i*gap+i*wd, wd, wd);
       fill(0,0,0);
        text("2010",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
 //2011
  noFill();

     stroke(0,90,140);
     rect(x, y+i*gap+i*wd, wd, wd);
     fill(255,255,255);
        text("2011",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
//2012
 noFill();

       stroke(0,0,102);
       rect(x, y+i*gap+i*wd, wd, wd);
       fill(255,255,255);
        text("2012",x+wd/2, y+i*gap+i*wd+wd/2);
i++;
 //2013
 noFill();
        stroke(0,0,0);
        rect(x, y+i*gap+i*wd, wd, wd);
        fill(255,255,255);
        text("2013",x+wd/2, y+i*gap+i*wd+wd/2);
i=0;

}
else if(strokeBy.equals("country")){
  noFill();
  stroke(30, 150, 255);
  rect(x, y, wd, wd);
  stroke(199, 21, 133);
  rect(x, y+gap+wd, wd, wd);
  fill(0,0,0);
  textSize(25);
  text("NZ",x+wd/2,y+wd/2);
  text("AU",x+wd/2,y+gap+wd+wd/2);

}
else if(strokeBy.equals("home")){
  noFill();
  stroke(30, 50, 155);
  rect(x, y, wd, wd);
  stroke(120, 21, 70);
  rect(x, y+gap+wd, wd, wd);
  fill(255,255,255);
  textSize(15);
  text("home",x+wd/2,y+wd/2);
  text("away",x+wd/2,y+gap+wd+wd/2);

}
else if(strokeBy.equals("team")){
textSize(18);
int i = 0;
for(Team t: teams){
  if(i<5){
  noFill();
        stroke(t.getColor().r,t.getColor().g,t.getColor().b);
        rect(x, y+i*gap+i*wd, wd, wd);
        fill(0,0,0);
        text(t.getShortName(),x+wd/2, y+i*gap+i*wd+wd/2);
        i++;
        }else{
        noFill();
        stroke(t.getColor().r,t.getColor().g,t.getColor().b);
        rect(x+wd+gap, y+(i-5)*gap+(i-5)*wd, wd, wd);
        fill(0,0,0);
        text(t.getShortName(),x+wd/2+wd+gap, y+(i-5)*gap+(i-5)*wd+wd/2);
        i++;
        }
}
}
}

  
}
  class Filters {
    public Filters() {
    }

    String getFilters() {
      String yrs = (active==null) ? "all" : yr;
      String tms = (activeTeam==null) ? "all" : activeTeam.getName();
      String cnt = (activeCountry==null) ? "both" : activeCountry;

      return "year- "+yrs+"     team- "+tms+"     country- "+cnt+"     "+seasonBy+"";
    }
  }

class YearFilter {
  float startX; 
  float startY; 
  float wd;
  float ht;
  public YearFilter() {
    startX = 20; 
    startY = 80; 
    wd = 130;
    ht =50;
  }
  void drawYearFilter() {
    fill(10, 170, 210);
    for (int i=0;i<8;i++) {
      rect(startX*i+wd*(i-1), startY, wd, ht);
    }
    fill(255);
    text("2008", startX+wd/2, startY+70/2);
    text("2009", startX*2+3*wd/2, startY+70/2);
    text("2010", startX*3+5*wd/2, startY+70/2);
    text("2011", startX*4+7*wd/2, startY+70/2);

    text("2012", startX*5+9*wd/2, startY+70/2);
    text("2013", startX*6+11*wd/2, startY+70/2);
    text("ALL", startX*7+13*wd/2, startY+70/2);
  }
}
class TeamFilter {
  float startX; 
  float startY; 
  float wd;
  float ht;
  public TeamFilter() {
    startX = 10; 
    startY = 80; 
    wd = 104;
    ht =50;
  }
  void drawTeamFilter() {
    fill(10, 170, 210);
    for (int i=0;i<12;i++) {
      rect(startX*i+wd*(i-1), startY, wd, ht);
    }
    fill(255);
    textSize(15);
    int i =1;
    for (Team t: teams) {
      String[] s = t.getName().split(" ");
      if (s.length==2) {
        text(s[0], startX*i+(2*i-1)*wd/2, startY+70/4);
        text(s[1], startX*i+(2*i-1)*wd/2, startY+70/2);
      }
      else if (s.length==3) {
        text(s[0]+" "+s[1], startX*i+(2*i-1)*wd/2, startY+70/4);
        text(s[2], startX*i+(2*i-1)*wd/2, startY+70/2);
      }
      else if (s.length==4) {
        text(s[0]+" "+s[1], startX*i+(2*i-1)*wd/2, startY+70/4);
        text(s[2]+" "+s[3], startX*i+(2*i-1)*wd/2, startY+70/2);
      }
      else if (s.length==5) {
        text(s[0]+" "+s[1], startX*i+(2*i-1)*wd/2, startY+70/5);
        text(s[2]+" "+s[3], startX*i+(2*i-1)*wd/2, startY+70/2.3);

        text(s[4], startX*i+(2*i-1)*wd/2, startY+70/1.5);
      }
      else {
        text(t.getName(), startX*i+(2*i-1)*wd/2, startY+70/3);
      }
      i++;
    }
    textSize(20);
    text("all", 1202, startY+70/2);
  }
  void clicked(float x, float y) {
  }
}

class CountryFilter {
  float startX; 
  float startY; 
  float wd;
  float ht;
  public CountryFilter() {
    startX = 320; 
    startY = 80; 
    wd = 130;
    ht =50;
  }

  void drawCountryFilter() {
    fill(10, 170, 210);

    rect(startX, startY, wd, ht);
    rect(startX+wd+20, startY, wd, ht);
    rect(startX+wd*2+40, startY, wd, ht);


    fill(255);
    textSize(20);
    text("New Zealand", startX+wd/2, startY+70/2);
    text("Australia", startX+3*wd/2+20, startY+70/2);
    text("both", startX+5*wd/2+40, startY+70/2);
  }
}


class FinalFilter {
  float startX; 
  float startY; 
  float wd;
  float ht;
  public FinalFilter() {
    startX =470; 
    startY = 80; 
    wd = 130;
    ht =50;
  }
  void drawFinalFilter() {
    fill(10, 170, 210);
    rect(startX, startY, wd, ht);
    rect(startX+wd+20, startY, wd, ht);
    rect(startX+wd*2+40, startY, wd, ht);

    fill(255);
    text("season", startX+wd/2, startY+70/2);
    text("finals", startX+3*wd/2+20, startY+70/2);
    text("both", startX+5*wd/2+40, startY+70/2);
  }
}

//choose to fill/stroke
class FilterColor {
  float wd;
  float ht;
  float x;
  float y;
  public FilterColor(float x) {
    wd=130;
    ht=50;
    this.x=x;
    this.y=80;
  }

  void drawFilterColor() {
    fill(10, 170, 210);

    rect(x-wd/2, y, wd, ht);
    rect(x+wd/2+20, y, wd, ht);
    fill(255);
    textAlign(CENTER);
    text("fill", x, y+ht/2+10);
    text("stroke", x+wd+20, y+ht/2+10);
  }

//returns -1 if not on the thing
//0 if on the FILL 1 if on the STROKE
  int on(float x){
    if(x>this.x-wd/2 &&x<this.x-wd/2+wd){return 0;}
    if(x>this.x+wd/2+20 &&x<this.x+wd/2+20+wd){return 1;}

    return -1;
  }
}


//===========================================================
// loading methods
//===========================================================

void loadDataVis() {
  loadTeams();
  years.add(loadYear(2008, "yr2008.txt"));
  years.add(loadYear(2009, "yr2009.txt"));
  years.add(loadYear(2010, "yr2010.txt"));
  years.add(loadYear(2011, "yr2011.txt"));
  years.add(loadYear(2012, "yr2012.txt"));
  years.add(loadYear(2013, "yr2013.txt"));
}
Year loadYear(int ynum, String txt) {
  ArrayList<Round> rnds = new ArrayList<Round>();

  //make 17 Round ready to be populated
  for (int i = 1; i < 18; i++) {
    rnds.add(new Round(i, new ArrayList<Game>()));
  }
  String[] lines; //each one is a line of the file
  try {
    lines = loadStrings(txt);
    for (String line:lines) {
      String[] gm = line.split(",");
      rnds.get(parseInt(gm[0]) - 1).addGame(new Game(new Date(gm[1]), new Time(gm[2]), teams
        .get(parseInt(gm[3])), teams.get(parseInt(gm[4])), new Venue(gm[5]), parseInt(gm[6]), parseInt(gm[7]), ynum));
    }
  }
  catch (Exception e) {
    println(e);
  }

  return new Year(ynum, rnds);
}


void loadTeams() {
  String[] ts;
  try
  {
    ts=loadStrings("TEAMS.txt");
    for (String s: ts) {
      String[] t = s.split(","); 
      teams.add(new Team(t[0], t[1]));
    }
  }
  catch(Exception e)
  { 
    println(e);
  }
  teams.get(0).setCol(new col(255,29,185));
  teams.get(1).setCol(new col(210,0,0));
  teams.get(2).setCol(new col(250,237,10));
  teams.get(3).setCol(new col(40,10,150));
  teams.get(4).setCol(new col(255,20,20));
  teams.get(5).setCol(new col(20,40,200));
  teams.get(6).setCol(new col(115,10,152));
  teams.get(7).setCol(new col(150,200,220));
  teams.get(8).setCol(new col(206,116,15));
  teams.get(9).setCol(new col(20,20,20));

  teams.get(0).setShortName("AT");
  teams.get(1).setShortName("CT");
  teams.get(2).setShortName("CP");
  teams.get(3).setShortName("MV");
  teams.get(4).setShortName("NS");
  teams.get(5).setShortName("NM");
  teams.get(6).setShortName("QF");
  teams.get(7).setShortName("SS");
  teams.get(8).setShortName("WM");
  teams.get(9).setShortName("WCF");

}

//===========================================================
// DATA HOLDING CLASSES
//===========================================================

class Year {
  private ArrayList<Round> rounds;
  private Team winner;
  private int yr;
  public Year(int y, ArrayList<Round> r) {
    this.yr=y;
    this.rounds = r;
    this.winner = rounds.get(rounds.size()-1).getGames().get(0).getWinner();
  }

  public Team getWinner() {
    return this.winner;
  }
  public int getYear() {
    return yr;
  }

  public ArrayList<Round> getRounds() {
    return rounds;
  }
}

class Round {
  private ArrayList<Game> games;
  private int roundNum;
  public Round(int rn, ArrayList<Game> g) {
    this.roundNum=rn;
    this.games=g;
  }

  public ArrayList<Game> getGames() {
    return games;
  }
  public void addGame(Game g) {
    this.games.add(g);
  }

  public int getRoundNum() {
    return roundNum;
  }

  public String toString() {
    return roundNum+"";
  }
}

class Game {
  private Date date;
  private Time time;
  private Team home;
  private int homeScore;
  private Team away;
  private int awayScore;
  private Venue venue;
  private int y;

  public Game(Date d, Time t, Team h, Team a, Venue v, int hs, int as, int y) {
    this.date=d;
    this.time =t;
    this.home =h;
    this.away=a;
    this.venue = v;
    this.homeScore = hs;
    this.awayScore=as;
    this.y = y;
  }

  public Date getDate() {
    return date;
  }
public int getYear(){
  return y;
}
  public Time getTime() {
    return time;
  }

  public Team getHome() {
    return home;
  }

  public Team getAway() {
    return away;
  }

  public String getString() {
    return home.getName()+" - "+homeScore+"\n"+away.getName()+" - "+awayScore+"\n at "+venue.getName()+"\n on "+date.toString();
  }

  public int getHomeScore() {
    return homeScore;
  }

  public int getAwayScore() {
    return awayScore;
  }

  public Venue getVenue() {
    return venue;
  }
  public Team getWinner() {
    if (homeScore>awayScore)return home;
    else if (awayScore>homeScore)return away;
    else return new Team("none", "draw");
  }
}

class Team {
  private String country;
  private String teamName;
  private String shortName;
  private col teamCol;

  public Team(String c, String tn) {
    this.country=c;
    this.teamName=tn;
  }
  public String getName() {
    return teamName;
  }
  public String getCountry() {
    return country;
  }
  public String toString() {
    return teamName;
  }
  public void setCol(col c){
    this.teamCol = c;
  }
  public col getColor(){
    return teamCol;
  }
  public void setShortName(String sh){
    this.shortName = sh;
  }
  public String getShortName(){
    return shortName;
  }
}

//===========================================================
// small classes with pretty much just getters and setters
//===========================================================

class Date {
  private String date;
  public Date(String d) {
    this.date=d;
  }

  public String toString() {
    return date;
  }
}

class Time {
  private String time;
  public Time(String t) {
    this.time=t;
  }
  public String toString() {
    return time;
  }
}

class Venue {
  private String name;
  public Venue(String n) {
    this.name=n;
  }
  public String getName() {
    return name;
  }
}

class col {
  float r;
  float g;
  float b;
  public col(float r, float g, float b) {
    this.r =r;
    this.g=g;
    this.b=b;
  }
}

class GameArc{
  float x;
  float y;
  float wd; 
  Game g; 
 // Team t;
  public GameArc(float x, float y, float wd, Game g){
this.x=x;
this.y=y;
this.wd=wd
this.g=g;
change=true;
  }
  boolean checkOn(float xm, float ym){
   if(dist(xm,ym,x,y)<wd){
      return true;
   }else {return false;}
  }
  void drawGameArc(){
    strokeWeight(15);
      col c1 = fm.getFill(g, g.getHome());
      col c2 = fm.getStroke(g, g.getHome());
      fill(c1.r, c1.g, c1.b);
      stroke(c2.r, c2.g, c2.b);
      arc(1140, 180, 100, 100, PI, TWO_PI);

      c1 = fm.getFill(g, g.getAway());
      c2 = fm.getStroke(g, g.getAway());
      fill(c1.r, c1.g, c1.b);
      stroke(c2.r, c2.g, c2.b);
      arc(1140, 180, 100, 100, 0, PI);

      fill(0);
      textSize(15);
      String info = g.getString();
      text(info,1140,300);

  }
}
