// GameBoard.pde

// 棋盤參數
final int REG_COLS      = 3;   // 橫向區域數
final int REG_ROWS      = 3;   // 縱向區域數
final int CEL_PER_REG   = 5;   // 每個區域幾格（長寬相同）
final int CELL_SIZE     = 50;  // 每格像素大小
final int MINES_PER_REG = 3;   // 每個區域地雷數（至少1）

final int TOTAL_COLS = REG_COLS * CEL_PER_REG; // 15
final int TOTAL_ROWS = REG_ROWS * CEL_PER_REG; // 15

// 棋盤左上角座標
final int BOARD_X = 30;
final int BOARD_Y = 75;

// 資料陣列
// board[r][c]: -1=地雷, 0~8=周圍地雷數
int[][] board     = new int[TOTAL_ROWS][TOTAL_COLS];
// cellState[r][c]: 0=蓋住, 1=翻開, 2=插旗
int[][] cellState = new int[TOTAL_ROWS][TOTAL_COLS];
// 9個區域的解鎖狀態
boolean[] regionUnlocked = new boolean[9];

boolean gameOver = false;
boolean gameWon  = false;

boolean firstClick = true;

//
// 初始化
//
void initBoard() {
  for (int r = 0; r < TOTAL_ROWS; r++)
    for (int c = 0; c < TOTAL_COLS; c++) {
      board[r][c]     = 0;
      cellState[r][c] = 0;
    }
  for (int i = 0; i < 9; i++) regionUnlocked[i] = false;
  gameOver        = false;
  gameWon         = false;
  pendingRegionID = -1;
  firstClick      = true;
}

// 第一次點擊後才呼叫，safeR/safeC 是第一格，周圍3x3都不放雷
void placeMines(int safeR, int safeC) {
  for (int regID = 0; regID < 9; regID++) {
    int startR = (regID / REG_COLS) * CEL_PER_REG;
    int startC = (regID % REG_COLS) * CEL_PER_REG;
    int placed  = 0;
    while (placed < MINES_PER_REG) {
      int r = startR + int(random(CEL_PER_REG));
      int c = startC + int(random(CEL_PER_REG));
      // 不能是地雷、不能在第一格的3x3範圍內
      boolean inSafeZone = (abs(r - safeR) + abs(c - safeC) <= 2);
      if (board[r][c] != -1 && !inSafeZone) {
        board[r][c] = -1;
        placed++;
      }
    }
  }
  // 計算每格地雷數（跨區域計算）
  for (int r = 0; r < TOTAL_ROWS; r++)
    for (int c = 0; c < TOTAL_COLS; c++)
      if (board[r][c] != -1)
        board[r][c] = countNeighborMines(r, c);
}

// 取得格子所屬的區域ID (0~8)
int getRegionID(int r, int c) {
  return (r / CEL_PER_REG) * REG_COLS + (c / CEL_PER_REG);
}

// 計算 (r,c) 在同一區域內的周圍地雷數
int countNeighborMines(int r, int c) {
  int count = 0;
  for (int dr = -1; dr <= 1; dr++)
    for (int dc = -1; dc <= 1; dc++) {
      if (dr == 0 && dc == 0) continue;
      int nr = r + dr, nc = c + dc;
      if (nr < 0 || nr >= TOTAL_ROWS || nc < 0 || nc >= TOTAL_COLS) continue;
      // 跨區域也算
      if (board[nr][nc] == -1) count++;
    }
  return count;
}

//
// 解鎖區域（答題正確後由 QuizScreen.pde 呼叫）
//
void unlockRegion(int regID) {
  if (regID < 0 || regID > 8) return;
  regionUnlocked[regID] = true;
  pendingRegionID        = -1;
  CallScreenID           = 2;
}

//
// 繪製遊戲畫面
//
void showGameBoard() {
  background(230);

  // 上方title
  fill(40);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("Knowledge or Boom!", BOARD_X, 40);

  // 繪製格子
  for (int r = 0; r < TOTAL_ROWS; r++)
    for (int c = 0; c < TOTAL_COLS; c++)
      drawCell(r, c);

  // 繪製區域分隔粗線
  stroke(50);
  strokeWeight(3);
  for (int rr = 0; rr <= REG_ROWS; rr++) {
    int y = BOARD_Y + rr * CEL_PER_REG * CELL_SIZE;
    line(BOARD_X, y, BOARD_X + TOTAL_COLS * CELL_SIZE, y);
  }
  for (int cc = 0; cc <= REG_COLS; cc++) {
    int x = BOARD_X + cc * CEL_PER_REG * CELL_SIZE;
    line(x, BOARD_Y, x, BOARD_Y + TOTAL_ROWS * CELL_SIZE);
  }
  strokeWeight(1);

  // 繪製未解鎖區域的覆蓋層
  for (int regID = 0; regID < 9; regID++)
    if (!regionUnlocked[regID])
      drawRegionCover(regID);

  // 右上角按鈕
  drawButton("主選單", width - 120, 20, 100, 35);
}

void drawCell(int r, int c) {
  int regID = getRegionID(r, c);
  if (!regionUnlocked[regID]) return; // 未解鎖的區域不畫格子

  int x = BOARD_X + c * CELL_SIZE;
  int y = BOARD_Y + r * CELL_SIZE;

  noStroke();

  if (cellState[r][c] == 0) {
    // 蓋住
    fill(170);
    rect(x + 1, y + 1, CELL_SIZE - 2, CELL_SIZE - 2);

  } else if (cellState[r][c] == 1) {
    if (board[r][c] == -1) {
      // 地雷（踩到了）
      fill(220, 70, 70);
      rect(x + 1, y + 1, CELL_SIZE - 2, CELL_SIZE - 2);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(22);
      text("*", x + CELL_SIZE / 2, y + CELL_SIZE / 2);
    } else {
      // 翻開安全格
      fill(210);
      rect(x + 1, y + 1, CELL_SIZE - 2, CELL_SIZE - 2);
      if (board[r][c] > 0) {
        fill(numberColor(board[r][c]));
        textAlign(CENTER, CENTER);
        textSize(18);
        text(board[r][c], x + CELL_SIZE / 2, y + CELL_SIZE / 2);
      }
    }

  } else if (cellState[r][c] == 2) {
    // 插旗
    fill(170);
    rect(x + 1, y + 1, CELL_SIZE - 2, CELL_SIZE - 2);
    fill(220, 50, 50);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("▶", x + CELL_SIZE / 2, y + CELL_SIZE / 2); // 之後可以用旗子的png圖片代替
  }
}

color numberColor(int n) {
  switch(n) {
    case 1: return color(30, 30, 220);
    case 2: return color(0, 150, 0);
    case 3: return color(220, 30, 30);
    case 4: return color(0, 0, 130);
    case 5: return color(160, 0, 0);
    case 6: return color(0, 160, 160);
    case 7: return color(0, 0, 0);
    default: return color(100);
  }
}

void drawRegionCover(int regID) {
  int regRow = regID / REG_COLS;
  int regCol = regID % REG_COLS;
  int x = BOARD_X + regCol * CEL_PER_REG * CELL_SIZE;
  int y = BOARD_Y + regRow * CEL_PER_REG * CELL_SIZE;
  int w = CEL_PER_REG * CELL_SIZE; // 250
  int h = CEL_PER_REG * CELL_SIZE; // 250

  // 圖片版（完成後取消註解，刪掉下方色塊）
  // image(imgRegionCover, x, y, w, h);

  // 暫時用色塊代替
  fill(90, 130, 190, 240);
  noStroke();
  rect(x, y, w, h);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(60);
  text("?", x + w / 2, y + h / 2 - 10);
  textSize(14);
  text("點擊答題解鎖", x + w / 2, y + h / 2 + 35);
}

//
// 點擊處理
//
void handleGameBoardClick() {
  if (gameOver || gameWon) return;

  // 返回主選單按鈕
  if (isInButton(mouseX, mouseY, width - 120, 20, 100, 35)) {
    CallScreenID = 1;
    return;
  }

  int c = (mouseX - BOARD_X) / CELL_SIZE;
  int r = (mouseY - BOARD_Y) / CELL_SIZE;
  if (r < 0 || r >= TOTAL_ROWS || c < 0 || c >= TOTAL_COLS) return;

  int regID = getRegionID(r, c);

  if (!regionUnlocked[regID]) {
    // 點擊鎖定區域 -> 觸發答題
    pendingRegionID = regID;
    CallScreenID    = 3;
    return;
  }

  // 右鍵插旗
  if (mouseButton == RIGHT) {
    if (cellState[r][c] == 0) cellState[r][c] = 2;
    else if (cellState[r][c] == 2) cellState[r][c] = 0;
    return;
  }

  // 左鍵：蓋住的格子才能點
  if (cellState[r][c] != 0) return;

  // 第一次點擊才放地雷
  if (firstClick) {
    placeMines(r, c);
    firstClick = false;
  }

  if (board[r][c] == -1) {
    // 踩雷
    cellState[r][c] = 1;
    gameOver        = true;
    CallScreenID    = 5;
    return;
  }

  revealCell(r, c);

  if (checkWin()) {
    gameWon      = true;
    CallScreenID = 4;
  }
}

// 翻開格子（空白格連鎖翻開，可跨越已解鎖的相鄰區域）
void revealCell(int r, int c) {
  if (r < 0 || r >= TOTAL_ROWS || c < 0 || c >= TOTAL_COLS) return;
  if (cellState[r][c] != 0) return;
  if (!regionUnlocked[getRegionID(r, c)]) return; // 未解鎖區域還是擋住
  
  cellState[r][c] = 1;
  
  if (board[r][c] == 0) {
    for (int dr = -1; dr <= 1; dr++)
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        revealCell(r + dr, c + dc);
      }
  }
}

// 勝利條件：全部區域都解鎖，且所有非地雷格都翻開
boolean checkWin() {
  for (int i = 0; i < 9; i++)
    if (!regionUnlocked[i]) return false;
  for (int r = 0; r < TOTAL_ROWS; r++)
    for (int c = 0; c < TOTAL_COLS; c++)
      if (board[r][c] != -1 && cellState[r][c] == 0)
        return false;
  return true;
}
