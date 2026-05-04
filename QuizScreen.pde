// QuizScreen.pde

void showQuizScreen() {
  background(50, 70, 130);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("答題畫面（待補）", width/2, height/2 - 40);
  text("目前要解鎖的區域：" + pendingRegionID, width/2, height/2);
  
  drawButton("【測試用 之後要改】直接解鎖", width/2 - 90, height/2 + 60, 180, 45);
  drawButton("放棄作答，回遊戲", width/2 - 90, height/2 + 120, 180, 45);

  // 讀取 questions.csv、顯示題目選項、判斷答對/錯
  // 答對後呼叫 unlockRegion(pendingRegionID)
}

void handleQuizClick() {
  if (isInButton(mouseX, mouseY, width/2 - 90, height/2 + 60, 180, 45)) {
    unlockRegion(pendingRegionID); // 測試用 之後要改成答對才呼叫
  }
  if (isInButton(mouseX, mouseY, width/2 - 90, height/2 + 120, 180, 45)) {
    pendingRegionID = -1;
    CallScreenID = 2;
  }
}
