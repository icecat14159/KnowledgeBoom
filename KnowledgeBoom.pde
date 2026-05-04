// KnowledgeBoom.pde

PFont mainFont;
PImage imgMenu, imgHelp, imgAboutUs, imgWin, imgLose, imgRegionCover;

// 畫面ID: 1=主選單 2=遊戲 3=答題 4=通關 5=失敗 6=關於我們 7=說明
int CallScreenID = 1;

// 哪個區域正在等待答題解鎖（-1=沒有）
int pendingRegionID = -1;

// 關於我們的文字（未完成 先亂打）
String teamMember  = "劉華欣　邱妍霓　趙嘉鋐\n阮玉方維　康祐愷　駱耘";
String thanksTerm  = "感謝......。";
String rightsTerm  = "本作品所有圖文皆為自創。\n不做任何商業用途，僅供教學使用。......";

void setup() {
  size(810, 840);
  frameRate(60);
  surface.setTitle("Knowledge or Boom!");

  // 載入字型
  mainFont = createFont("font/NotoSansTC-Black.otf", 20);
  textFont(mainFont);

  // 載入圖片（有圖片之後再取消註解）
  // imgMenu        = loadImage("pic/menu_bg.png");
  // imgHelp        = loadImage("pic/help_bg.png");
  // imgAboutUs     = loadImage("pic/aboutus_bg.png");
  // imgWin         = loadImage("pic/win_screen.png");
  // imgLose        = loadImage("pic/lose_screen.png");
  // imgRegionCover = loadImage("pic/region_cover.png");

  initBoard(); // 初始化踩地雷棋盤
}

void draw() {
  switch (CallScreenID) {
    case 2:  showGameBoard();   break;
    case 3:  showQuizScreen();  break;
    case 4:  showWinScreen();   break;
    case 5:  showLoseScreen();  break;
    case 6:  showAboutUs();     break;
    case 7:  showManual();      break;
    default: showMenuPage();    break; // case 1
  }
}

void mousePressed() {
  switch (CallScreenID) {
    case 1:  handleMenuClick();      break;
    case 2:  handleGameBoardClick(); break;
    case 3:  handleQuizClick();      break;
    case 4:  handleWinClick();       break;
    case 5:  handleLoseClick();      break;
    case 6:  handleAboutUsClick();   break;
    case 7:  handleManualClick();    break;
  }
}

//
// 通用工具：畫按鈕 / 判斷滑鼠在不在按鈕內
//
void drawButton(String label, int x, int y, int w, int h) {
  fill(255);
  stroke(120);
  strokeWeight(1.5);
  rect(x, y, w, h, 8); // 圓角
  fill(60);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(16);
  text(label, x + w/2, y + h/2);
}

boolean isInButton(int mx, int my, int x, int y, int w, int h) {
  return mx >= x && mx <= x + w && my >= y && my <= y + h;
}
