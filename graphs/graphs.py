#! /usr/bin/python3

import matplotlib.pyplot as plt
import numpy as np

# Maker constants
LIQUIDATION_RATIO = 0.66
LIQUIDATION_FEE = 0.13

# Our constants
INSURANCE_RATIO = 0.50
INITIAL_COLLATERAL	= 100
DAI_INSURED_FEE = 0.1				# in $

# https://stackoverflow.com/a/13124859/5752262
def draw_arrow(A, B, color='black'):
    plt.arrow(A[0], A[1], B[0] - A[0], B[1] - A[1], head_width=1, length_includes_head=True, color=color)


def do_graph(points, title):
	plt.figure(figsize=(18, 12))

	x_range = range(INITIAL_COLLATERAL)

	plt.plot(x_range, [LIQUIDATION_RATIO * x for x in x_range], label='Liquidation threshold', color='red')
	plt.plot(x_range, [INSURANCE_RATIO * x for x in x_range], label='Insurance threshold', color='orange')

	texts = ['' for _ in range(len(points))]
	for p, t in zip(points, texts):
		plt.plot(p[0], p[1], color='k', marker='o', label=str((int(p[0]), int(p[1]))))
	
	for p1, p2 in zip(points, points[1:]):
		draw_arrow(p1, p2)

	'''
	for point in points:
		plt.scatter(point[0], point[1], color='k', marker='o')
		plt.text(point[0]+.5, point[1]+.5, 'initial', fontsize=20)
	'''
	draw_arrow(points[3], points[-1], color='green')

	plt.title(title, fontsize=30)
	plt.legend(fontsize=18)
	plt.xticks(fontsize=26)
	plt.yticks(fontsize=26)
	plt.xlabel("Collateral", fontsize=26)
	plt.ylabel("Debt\n", fontsize=26)
	#plt.show()
	#plt.savefig(os.path.join(config.path, 'data', 'weight_function_example.png'))

def next_point(collateral, debt, fee=0):
	# step left as far as possible
	new_collateral = debt / LIQUIDATION_RATIO
	step = collateral - new_collateral
	# step down by the same amount
	new_debt = debt - step + fee
	return new_collateral, new_debt

def danger(collateral, debt):
	return (debt / collateral > INSURANCE_RATIO)

def liquidated(collateral, debt):
	return (debt / collateral > LIQUIDATION_RATIO)


def simulate_saving(
	# the debt-to-collateral ratio initially (the "good case", must be lower than LIQUIDATION_RATIO)
	initial_ratio,
	# a problem emerges then the collateral is worth only collateral_drop of its initial value
	collateral_drop,
	fee=DAI_INSURED_FEE,
	save=False
	):
	print("Simulating with initial ratio", initial_ratio, ", collateral drop", collateral_drop) 

	# The Saver kicks in!
	collateral_to_save = INITIAL_COLLATERAL * collateral_drop
	debt_to_save = INITIAL_COLLATERAL * initial_ratio

	points = [
	(0, 0),
	(INITIAL_COLLATERAL, 0),
	(INITIAL_COLLATERAL, INITIAL_COLLATERAL * initial_ratio),
	(collateral_to_save, debt_to_save)
	]

	curr_collateral = collateral_to_save
	curr_debt = debt_to_save

	if liquidated(curr_collateral, curr_debt):
		print("Liquidated from collateral", curr_collateral, ", debt", curr_debt)
		print("Game over.")
		return 0, curr_debt * (1.0 - LIQUIDATION_FEE)
	
	if not danger(curr_collateral, curr_debt):
		print("No danger with collateral", curr_collateral, ", debt", curr_debt)
		print("Trying next simulation.")
		return curr_collateral, curr_debt

	print("Saving from:", collateral_to_save, debt_to_save)

	num_steps = 0
	while danger(curr_collateral, curr_debt) and num_steps < 100:
		next_collateral, next_debt = next_point(curr_collateral, curr_debt, fee)
		print("Next point:", next_collateral, next_debt, "danger:", danger(next_collateral, next_debt))
		points.append((next_collateral, curr_debt))
		points.append((next_collateral, next_debt))
		curr_collateral = next_collateral
		curr_debt = next_debt
		num_steps += 1

	str_initial_ratio = str(round(initial_ratio * 100))
	str_collateral_drop = str(round((1.0 - collateral_drop) * 100))
	title = ("Initial ratio " + str_initial_ratio + 
		" % / collateral drop: " + str_collateral_drop + "% / " + 
		str(num_steps) + " steps"
		)
	do_graph(points, title=title)

	if save:
		filename = 'dai-insured-' + str_initial_ratio + '-' + str_collateral_drop
		plt.savefig('img/' + filename + '.png')
	else:
		plt.show()

	return curr_collateral, curr_debt


def main():
	'''
	# Case 1: one step is enough to get out of Danger Area
	simulate_saving(initial_ratio=0.45, collateral_drop=0.8, save=True)

	# Case 2: one step is not enough to get out of Danger Ares
	simulate_saving(initial_ratio=0.45, collateral_drop=0.7, save=True)
	'''

	for fee in [5]:
		# initial ratio can't go higher than 66% by definition
		for ir in [0.5]:
			# new collateral value from 5% to 95% of the initial value
			for cd in [0.95, 0.90]:
				print()
				#print("ir, cd, fee", ir, cd, fee)
				final_point = simulate_saving(initial_ratio=ir, collateral_drop=cd, 
					fee=fee,
					save=True)
				print("Final point: collateral", final_point[0], "debt", final_point[1])



if __name__ == "__main__":
	main()