// WinScreen.pde

void showWinScreen() {
  background(255, 230, 80);
  fill(60, 40, 0);
  textAlign(CENTER, CENTER);
  textSize(48);
  
  drawButton("再玩一次", width/2 - 80, height/2 + 60, 160, 50);
  drawButton("回主選單", width/2 - 80, height/2 + 130, 160, 50);

  // 換成 imgWin 圖、調整版面
}

void handleWinClick() {
  if (isInButton(mouseX, mouseY, width/2 - 80, height/2 + 60, 160, 50)) {
    initBoard(); CallScreenID = 2;
  }
  if (isInButton(mouseX, mouseY, width/2 - 80, height/2 + 130, 160, 50)) {
    initBoard(); CallScreenID = 1;
  }
}
