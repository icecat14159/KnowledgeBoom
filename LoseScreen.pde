// LoseScreen.pde

void showLoseScreen() {
  background(60, 30, 30);
  fill(255, 100, 100);
  textAlign(CENTER, CENTER);
  textSize(48);
  
  drawButton("再玩一次", width/2 - 80, height/2 + 60, 160, 50);
  drawButton("回主選單", width/2 - 80, height/2 + 130, 160, 50);

  // 換成 imgLose 圖、調整版面
}

void handleLoseClick() {
  if (isInButton(mouseX, mouseY, width/2 - 80, height/2 + 60, 160, 50)) {
    initBoard(); CallScreenID = 2;
  }
  if (isInButton(mouseX, mouseY, width/2 - 80, height/2 + 130, 160, 50)) {
    initBoard(); CallScreenID = 1;
  }
}
