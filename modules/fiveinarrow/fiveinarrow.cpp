#include "fiveinarrow.h"
using namespace std;


void FiveInArrow::_bind_methods() {
	ClassDB::bind_method(D_METHOD("searchBestPosition", "array2D", "row_num", "isAI"), &FiveInArrow::searchBestPosition);
	ClassDB::bind_method(D_METHOD("calBoardScore"), &FiveInArrow::calBoardScore);
	ClassDB::bind_method(D_METHOD("updateArray2D", "grid"), &FiveInArrow::updateArray2D);
	ClassDB::bind_method(D_METHOD("checkLink", "x", "y"), &FiveInArrow::checkLink);
	ClassDB::bind_method(D_METHOD("setMaxDepth", "max"), &FiveInArrow::setMaxDepth);
	ClassDB::bind_method(D_METHOD("setNear", "value"), &FiveInArrow::setNear);
}

FiveInArrow::FiveInArrow() {
	/*
	score_map["11111"] = 200000;
	score_map["11110"] = 50000;
	score_map["01111"] = 50000;
	score_map["11101"] = 25000;
	score_map["11011"] = 30000;
	score_map["10111"] = 25000;
	score_map["11100"] = 10000;
	score_map["00111"] = 10000;
	score_map["01011"] = 2500;
	score_map["10110"] = 2500;
	score_map["11010"] = 1500;
	score_map["10011"] = 1400;
	score_map["11001"] = 1400;
	score_map["10101"] = 1300;
	score_map["00111"] = 1200;
	score_map["11100"] = 1200;
	score_map["01100"] = 500;
	score_map["00110"] = 500;
	score_map["11000"] = 500;
	score_map["00011"] = 500;
	score_map["01010"] = 200;
	score_map["01001"] = 100;
	score_map["10010"] = 100;
	score_map["10001"] = 50;
	*/
	score_map["11111"] = 2000000;

	score_map["11110"] = 100000;
	score_map["11101"] = 40000;
	score_map["11011"] = 40000;
	score_map["10111"] = 40000;
	score_map["01111"] = 40000;

	score_map["01110"] = 4000;
	score_map["01101"] = 2000;
	score_map["01011"] = 2000;
	score_map["00111"] = 2000;

	score_map["10110"] = 2000;
	score_map["10101"] = 1600;
	score_map["10011"] = 1500;

	score_map["11010"] = 2000;
	score_map["11001"] = 1500;
	score_map["11100"] = 2000;

	score_map["10001"] = 80;
	score_map["10010"] = 100;
	score_map["10100"] = 100;
	score_map["11000"] = 100;

	score_map["01001"] = 100;
	score_map["01010"] = 150;
	score_map["01100"] = 200;

	score_map["00101"] = 100;
	score_map["00110"] = 200;
	score_map["00011"] = 100;

	score_map["00001"] = 10;
	score_map["00010"] = 20;
	score_map["00100"] = 40;
	score_map["01000"] = 20;
	score_map["10000"] = 10;

	return;
}

void FiveInArrow::setMaxDepth(int max_depth) {
	if (max_depth > 5)
		MAX_DEPTH = 5;
	if (max_depth < 1)
		MAX_DEPTH = 1;
	MAX_DEPTH = max_depth;
}


void FiveInArrow::setNear(int near) {
	NEAR = near;
}

bool check_in_board_left(int x , int y) {
	return x > 0 && y > 0 ;
}

bool check_in_board_right(int x, int y) {
	return x < BOARD_SIZE - 1 && y < BOARD_SIZE - 1;
}

Array FiveInArrow::checkLink(int pos_y, int pos_x) {
	Array array_t;
	int current = array2D[pos_x][pos_y];

	for (int i = 0; i < 4; i++) {
		int left = 0;
		int right = 0;
		int x_step = Direction[i][0];
		int y_step = Direction[i][1];

		while (left < 5) {
			int x = pos_x - left * Direction[i][0];
			int y = pos_y - left * Direction[i][1];
			if (array2D[x][y] != current) {
				left--;
				break;
			}
			if (x > 0 && x > 0)
				left++;
			else {
				break;
			}
		}

		while (right < 5) {
			int x = pos_x + right * Direction[i][0];
			int y = pos_y + right * Direction[i][1];
			if (array2D[x][y] != current) {
				right--;
				break;
			}
			if (x < BOARD_SIZE - 1 && y < BOARD_SIZE - 1 ) {
				right++;
			} else {
				break;
			}
			
		}
		if (left == 5)
			left--;
		if (right == 5)
			right--;

		if (left + right >= 4) {
			for (int p = -left; p <= right; p++) {
				array_t.append(pos_y + p * Direction[i][1]);
				array_t.append(pos_x + p * Direction[i][0]);
			}

			left = 0;
			right = 0;
		}
	}

	return array_t;
}

void FiveInArrow::updateArray2D(const Array &grid) {
	int arrayTemp[BOARD_SIZE][BOARD_SIZE];
	int x = 0;
	int y = 0;
	for (int i = 0; i < grid.size(); i++) {
		x = i / BOARD_SIZE;
		y = i % BOARD_SIZE;
		arrayTemp[x][y] = grid[i];
		if (arrayTemp[x][y] > 0)
			array2D[x][y] = BLACK;
		else if (arrayTemp[x][y] < 0)
			array2D[x][y] = WHITE;
		else
			array2D[x][y] = DEFAULT;
	}
}

Vector2i FiveInArrow::searchBestPosition(const Array &grid, int len_tile, bool isAI) {
	int arrayTemp[20][20];
	int x = 0;
	int y = 0;
	for (int i = 0; i < grid.size(); i++) {
		x = i / BOARD_SIZE;
		y = i % BOARD_SIZE;
		arrayTemp[x][y] = grid[i];
		if (arrayTemp[x][y] > 0)
			array2D[x][y] = BLACK;
		else if (arrayTemp[x][y] < 0)
			array2D[x][y] = WHITE;
		else
			array2D[x][y] = 0;
	}

	alphaBeta(MAX_DEPTH, std::numeric_limits<int>::min(), std::numeric_limits<int>::max(), isAI);
	return Vector2i(bestPoint.y, bestPoint.x);
}

bool FiveInArrow::isLand(int x, int y) {
	for (int i = -NEAR; i < NEAR + 1; i++)
		for (int j = -NEAR; j < NEAR + 1; j++) {
			if (i != 0 || j != 0)
				if (x + i >= 0 && x + i < BOARD_SIZE && y + j >= 0 && j + y < BOARD_SIZE && array2D[x + i][j + y] != 0) {
					return false;
				}
		}
	return true;
}

int pos_score(int x, int y) {
	float center = 1.0f + BOARD_SIZE / 2 - 0.5f;
	int score = BOARD_SIZE * POS_SCORE - abs(1.0f * x - center) * POS_SCORE - abs(1.0f * y - center) * POS_SCORE;
	return score * (float(rand()%10) / 100 + 0.9);
}

int FiveInArrow::alphaBeta(int depth, int alpha, int beta, bool isAI) {
	if (depth == 0) {
		SearchCount++;
		return calBoardScore();
	}

	if (!isAI) {
		int maxEval = std::numeric_limits<int>::min();
		// 遍历棋盘上的每个空位
		for (int row = 0; row < BOARD_SIZE; row++) {
			for (int col = 0; col < BOARD_SIZE; col++) {
				if (array2D[row][col] == DEFAULT) {
					if (isLand(row, col))
						continue;
					array2D[row][col] = BLACK; // 假设当前位置下黑子
					int eval = alphaBeta(depth - 1, alpha, beta, true) + pos_score(row, col);
					maxEval = std::max(maxEval, eval);
					//alpha = std::max(alpha, eval);
					if (eval > alpha) {
						alpha = eval;
						if (depth == MAX_DEPTH) {
							bestPoint.x = row;
							bestPoint.y = col;
						}
					}

					array2D[row][col] = DEFAULT; // 恢复原状态
					if (beta <= alpha) {
						break; // 剪枝
					}
				}
			}
		}
		return maxEval;
	} else {
		int minEval = std::numeric_limits<int>::max();
		// 遍历棋盘上的每个空位
		for (int row = 0; row < BOARD_SIZE; row++) {
			for (int col = 0; col < BOARD_SIZE; col++) {
				if (array2D[row][col] == 0) {
					if (isLand(row, col))
						continue;
					array2D[row][col] = WHITE; // 假设当前位置下白子
					int eval = alphaBeta(depth - 1, alpha, beta, false) - pos_score(row, col);
					minEval = std::min(minEval, eval);
					// beta = std::min(beta, eval);
					if (eval < beta) {
						beta = eval;
						if (depth == MAX_DEPTH) {
							bestPoint.x = row;
							bestPoint.y = col;
						}
					}

					array2D[row][col] = DEFAULT; // 恢复原状态

					if (beta <= alpha) {
						break; // 剪枝
					}
				}
			}
		}
		return minEval;
	}
}

int countSubstringOccurrences(const std::string &mainString, const std::string &substring) {
	int count = 0;
	size_t pos = mainString.find(substring, 0);

	while (pos != std::string::npos) {
		count++;
		pos = mainString.find(substring, pos + substring.length());
	}

	return count;
}

int FiveInArrow::calBoardScore() {
	// 遍历棋盘上的每个位置
	int aiScore = 0;
	int playerScore = 0;
	Vector<string> aiString;
	Vector<string> playerString;
	//  "-"
	for (int i = 0; i < BOARD_SIZE; i++) {
		string ai_temp = "";
		string player_temp = "";
		for (int j = 0; j < BOARD_SIZE; j++) {
			ai_temp += transTag(array2D[i][j], true);
			player_temp += transTag(array2D[i][j], false);
		}
		aiString.append(ai_temp);
		playerString.append(player_temp);
	}

	//  "|"
	for (int i = 0; i < BOARD_SIZE; i++) {
		string ai_temp = "";
		string player_temp = "";
		for (int j = 0; j < BOARD_SIZE; j++) {
			ai_temp += transTag(array2D[j][i], true);
			player_temp += transTag(array2D[j][i], false);
		}
		aiString.append(ai_temp);
		playerString.append(player_temp);
	}
	//  "\"
	for (int i = -BOARD_SIZE + 5; i < BOARD_SIZE - 4; i++) {
		string ai_temp = "";
		string player_temp = "";
		for (int j = 0; i + j < BOARD_SIZE && j < BOARD_SIZE; j++) {
			if (i + j >= 0) {
				ai_temp += transTag(array2D[i + j][j], true);
				player_temp += transTag(array2D[i + j][j], false);
			}
		}
		aiString.append(ai_temp);
		playerString.append(player_temp);
	}
	// "/"
	for (int i = 4; i < BOARD_SIZE * 2 - 5; i++) {
		string ai_temp = "";
		string player_temp = "";
		for (int j = 0; j < BOARD_SIZE; j++) {
			if (i - j >= 0 && i - j < BOARD_SIZE) {
				ai_temp += transTag(array2D[i - j][j], true);
				player_temp += transTag(array2D[i - j][j], false);
			}
		}
		aiString.append(ai_temp);
		playerString.append(player_temp);
	}

	for (int i = 0; i < aiString.size(); i++) {
		if (countSubstringOccurrences(aiString[i], "1") == 0)
			continue;
		for each (auto it in score_map) {
			aiScore += it.second * countSubstringOccurrences(aiString[i], it.first);
		}
	}
	for (int i = 0; i < playerString.size(); i++) {
		if (countSubstringOccurrences(playerString[i], "1") == 0) {
			continue;
		}
		for each (auto it in score_map) {
			playerScore += it.second * countSubstringOccurrences(playerString[i], it.first);
		}
	}

	PLAYERSCORE = playerScore;
	AISCORE = aiScore;
	return (playerScore - aiScore) * (float(rand() % 10) / 1000 + 0.99);
}
char FiveInArrow::transTag(int num, bool isAI) {
	int matchTag = isAI ? WHITE : BLACK;
	if (num == matchTag)
		return '1';
	if (num == -matchTag)
		return '*';
	if (num == 0)
		return '0';
	else
		return '#';
}
int FiveInArrow::checkCrossBorder(int pos) {
	return pos >= BOARD_SIZE || pos < 0;
}

Vector<std::string> FiveInArrow::split(const char (*str_arr)[9], std::string pattern) {
	Vector<std::string> result;
	for (int i = 0; i < 4; i++) {
		string str = str_arr[i];
		str += pattern;
		int size = str.size();
		for (int i = 0; i < size; i++) {
			auto pos = str.find(pattern, i);
			if (pos < size) {
				std::string s = str.substr(i, pos - i);
				result.push_back(s);
				i = pos + pattern.size() - 1;
			}
		}
	}
	return result;
}
