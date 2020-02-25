import ensembling as ens
import numpy as np
import matplotlib.pyplot as plt

from randomforest import RandomForest
from gradientboostedtree import GradientBoostedTrees


def experiment_trees(ds_type, model_cls, iter_vals, iter_over, title, x_label,
                     show=True, image_name=None, iter_labels=None,
                     **model_params):
    sin_test_rmse = None
    if ds_type == 'sin':
        data_train, _ = ens.generate_sin_data(n=100, scale=0.2)
        data_test, sin_test_rmse = ens.generate_sin_data(n=1000, scale=0.2)
        tattr = 't'
    elif ds_type == 'boston':
        data_train, data_test = ens.generate_boston_housing()
        tattr = 'medv'
    else:
        raise ValueError()

    rng = np.random.RandomState(10)
    ens.generate_plot(
        data_train, data_test, tattr=tattr,
        model_cls=model_cls,
        iterate_over=iter_over, iterate_values=iter_vals,
        title=title,
        xlabel=x_label,
        rng=rng,
        iterate_labels=iter_labels,
        bayes_rmse=sin_test_rmse,
        **model_params
        )
    if image_name is not None:
        plt.savefig(image_name)
    if show: plt.show()


if __name__ == '__main__':
    show = True
    ens.experiment_tree_sin(show=show)
    ens.experiment_tree_housing(show=show)

    rand_forest_iter_trees = [1, 2, 10, 20, 50, 100, 200]
    rand_forest_iter_features = [lambda n: 2, lambda n: n / 2, lambda n: n]
    grad_boost_iter_trees = [1, 2, 10, 20, 50, 100, 200, 500, 1000]
    grad_boost_betas = [0.1, 0.2, 0.5, 1.0]

    experiment_trees(
        'sin', RandomForest, rand_forest_iter_trees,
        'n_trees', 'Random Forest', 'Number of trees',
        show=show, image_name='rand_forest_sin.png')
    experiment_trees(
        'boston', RandomForest, rand_forest_iter_trees,
        'n_trees', 'Random Forest', 'Number of trees',
        show=show, image_name='rand_forest_boston.png')
    experiment_trees(
        'boston', RandomForest, rand_forest_iter_features,
        'max_features', 'Random Forest', 'Max features',
        iter_labels=['2', 'n/2', 'n'], n_trees=200,
        show=show, image_name='rand_forest_boston_max_f.png')

    for beta in grad_boost_betas:
        print(f'Learning iteration, beta={beta}')
        experiment_trees(
            'sin', GradientBoostedTrees, grad_boost_iter_trees,
            'n_trees', f'Gradient boosted trees, beta = {beta}',
            'Number of trees', beta=beta,
            show=show,
            image_name=f'grad_boost_sin_{str(beta).replace(".", "_")}.png')

    for beta in grad_boost_betas:
        print(f'Learning iteration, beta={beta}')
        experiment_trees(
            'boston', GradientBoostedTrees, grad_boost_iter_trees,
            'n_trees', f'Gradient boosted trees, beta = {beta}',
            'Number of trees', beta=beta,
            show=show,
            image_name=f'grad_boost_boston_{str(beta).replace(".", "_")}.png'
            )
