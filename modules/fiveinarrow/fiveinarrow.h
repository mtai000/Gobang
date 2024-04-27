#pragma once

#include "core/object/ref_counted.h"
#include <limits>
#include <map>
#include <string>

#define BOARD_SIZE 14
#define POS_SCORE 2
#define BLACK 1
#define WHITE 2
#define DEFAULT 0
class FiveInArrow : public RefCounted {
	GDCLASS(FiveInArrow, RefCounted);

protected:
	static void _bind_methods();

private:
	int array2D[BOARD_SIZE][BOARD_SIZE];
	bool isLand(int x, int y);
	int checkCrossBorder(int pos);
	std::map<std::string, int> score_map;
	Vector<std::string> split(const char (*str_arr)[9], std::string pattern);
	int Direction[4][2] = { { 0, 1 }, { 1, 0 }, { 1, 1 }, { 1, -1 } };
	int MAX_DEPTH = 1;
	int NEAR = 1;

public:
	FiveInArrow();

	int alphaBeta(int depth, int alpha, int beta, bool isAI);
	int PLAYERSCORE = 0;
	int AISCORE = 0;
	struct BestPoint {
		int x = 0;
		int y = 0;
	} bestPoint;
	int SearchCount = 0;
	char transTag(int num, bool isAI);
	Vector2i searchBestPosition(const Array &grid, int len_tile, bool isAI);
	int calBoardScore();
	void updateArray2D(const Array &grid);
	Array checkLink(int pos_y, int pos_x); 
	void setMaxDepth(int max_depth);
	void setNear(int near);
};
