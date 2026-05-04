// AboutUs.pde

void showAboutUs() {
  background(245, 240, 230);
  fill(50);
  textAlign(CENTER, CENTER);
  textSize(20);
  //text("...", width/2, height/2);
  drawButton("返回主選單", width/2 - 80, 770, 160, 45);
  // 團隊介紹、致謝、版權宣告
}
void handleAboutUsClick() {
  if (isInButton(mouseX, mouseY, width/2 - 80, 770, 160, 45)) CallScreenID = 1;
}
