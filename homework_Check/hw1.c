#include <stdlib.h>
#include <stdio.h>

int main(int argc, char const *argv[])
{
	int num_lem, price_lem;
	float cost_lemo, profit;

	scanf("%d %d %f", &num_lem, &price_lem, &cost_lemo);

	profit = (num_lem * price_lem) - (num_lem * cost_lemo);

	printf("Carla made %.2f of profit today.\n", profit );
	 
	return 0;
}