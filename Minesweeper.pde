import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; 
private ArrayList <MSButton> mines; 

void setup()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS]; 
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        buttons[r][c] = new MSButton(r, c);
    mines = new ArrayList <MSButton>(); 
    setMines();
}

public void setMines()
{
  while (mines.size() < 50) {
    int r = (int)(Math.random()*20);
    int c = (int)(Math.random()*20);
    if (!mines.contains(buttons[r][c]) ) {
      mines.add(buttons[r][c]);
      System.out.println(r + " " + c);
    }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon()
{
    int count  = 0;
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        if(buttons[r][c].clicked == true && buttons[r][c].flagged == false)
          count++;
    if(count == NUM_ROWS*NUM_COLS-mines.size())
      return true;
    return false;
}

public void displayLosingMessage()
{
 buttons[9][6].setLabel("Y");
 buttons[9][7].setLabel("O");
 buttons[9][8].setLabel("U");
 buttons[9][9].setLabel(" ");
 buttons[9][10].setLabel("L");
 buttons[9][11].setLabel("O");
 buttons[9][12].setLabel("S");
 buttons[9][13].setLabel("E");
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        if(mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
          buttons[r][c].mousePressed();
    noLoop();
}

public void displayWinningMessage()
{
 buttons[9][6].setLabel("Y");
 buttons[9][7].setLabel("O");
 buttons[9][8].setLabel("U");
 buttons[9][9].setLabel(" ");
 buttons[9][10].setLabel("W");
 buttons[9][11].setLabel("I");
 buttons[9][12].setLabel("N");
 buttons[9][13].setLabel("!");
}

public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}

public int countMines(int row, int col)
{
    int numMines = 0;
    
    for(int r = row-1; r <= row+1; r++)
      for(int c = col-1; c <= col+1; c++)
        if(isValid(r, c))
          if(mines.contains(buttons[r][c]))
            numMines++;
    return numMines;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
public MSButton ( int row, int col )
{
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); 
}

public void mousePressed() 
{
    clicked = true;
    if(mouseButton == RIGHT){
      flagged = !flagged;
      if(flagged == false)
        clicked = false;
    }
    else if(mines.contains( this ))
      displayLosingMessage();
    else if(countMines(myRow, myCol) > 0)
      setLabel(countMines(myRow, myCol));
    else{ 
      for(int r = myRow-1; r <= myRow+1; r++)
       for(int c = myCol-1; c <= myCol+1; c++)
          if(isValid(r, c))
            if(!(mines.contains(buttons[r][c])) && buttons[r][c].clicked == false)
              buttons[r][c].mousePressed(); 
            }
  
}

public void draw () 
{    
    if(flagged)
        fill(0);
    else if(clicked && mines.contains(this)) 
        fill(255,0,0);
    else if(clicked)
        fill(200);
    else 
        fill(100);
    rect(x, y, width, height);
    fill(0);
    text(myLabel,x+width/2,y+height/2);
}

public void setLabel(String newLabel)
{
    myLabel = newLabel;
}

public void setLabel(int newLabel)
{
    myLabel = "" + newLabel;
}

public boolean isFlagged()
{
    return flagged;
}
}
