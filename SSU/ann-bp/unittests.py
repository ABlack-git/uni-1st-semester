import unittest
import numpy as np
from layers import LinearLayer, ReLULayer, SoftmaxLayer, LossCrossEntropy


class TestLinearLayer(unittest.TestCase):

    def setUp(self) -> None:
        self.tolerance = 1e-05
        rng = np.random.RandomState(1234)
        self.layer = LinearLayer(3, 3, rng, "test_linear")
        self.layer.W = np.array([[0.25, 0.125, 0.5], [0.1, 0.2, 0.3], [0.45, 0.1, 0.75]])
        self.layer.b = np.array([0.25, 0.5, 0.75])
        self.test_input = np.array([[1.25, 1.35, 5]])
        self.test_output = np.array([[2.9475, 1.42625, 5.53]])
        self.test_multi_input = np.array([[1.25, 1.35, 5], [1, 2, 3]])
        self.test_multi_output = np.array([[2.9475, 1.42625, 5.53], [2.05, 1.325, 4.1]])
        self.delta_next = np.array([1, 1, 1])
        self.delta_this = np.array([0.875, 0.6, 1.3])
        self.delta_next_multiple = np.array([[0.12, 0.4, 0.33], [1, 0.2, 0.78]])
        self.delta_this_multiple = np.array([[0.245, 0.191, 0.3415], [0.665, 0.374, 1.055]])

    def test_forward(self):
        out = self.layer.forward(self.test_input)
        self.assertEqual(out.shape, self.test_output.shape)
        np.testing.assert_allclose(out, self.test_output, rtol=self.tolerance)

    def test_multiple_forward(self):
        out = self.layer.forward(self.test_multi_input)
        self.assertEqual(out.shape, self.test_multi_output.shape)
        np.testing.assert_allclose(out, self.test_multi_output, rtol=self.tolerance)

    def test_delta(self):
        delta = self.layer.delta(self.test_output, self.delta_next)
        self.assertEqual(delta.shape, self.delta_this.shape)
        np.testing.assert_allclose(delta, self.delta_this, rtol=self.tolerance)

    def test_delta_multiple(self):
        delta = self.layer.delta(self.test_multi_output, self.delta_next_multiple)
        self.assertEqual(delta.shape, self.delta_this_multiple.shape)
        np.testing.assert_allclose(delta, self.delta_this_multiple, rtol=self.tolerance)

    def test_grad(self):
        pass

    def test_grad(self):
        pass


class TestRelu(unittest.TestCase):

    def setUp(self) -> None:
        self.test_input = np.array([[1.25, -1, 5]])
        self.test_out = np.array([[1.25, 0, 5]])
        self.test_multi_input = np.array([[1.25, 1.35, -1], [1, 0, 3]])
        self.test_multi_out = np.array([[1.25, 1.35, 0], [1, 0, 3]])
        self.delta_next = np.array([[1, 1, 1]])
        self.delta_this = np.array([[1, 0, 1]])
        self.delta_next_multi = np.array([[0.12, 0.4, 0.33], [1, 0.2, 0.78]])
        self.delta_this_multi = np.array([[0.12, 0.4, 0], [1, 0, 0.78]])
        self.layer = ReLULayer("test_relu")

    def test_forward(self):
        out = self.layer.forward(self.test_input)
        self.assertEqual(out.shape, self.test_out.shape)
        np.testing.assert_equal(out, self.test_out)

    def test_forward_multiple(self):
        out = self.layer.forward(self.test_multi_input)
        self.assertEqual(out.shape, self.test_multi_out.shape)
        np.testing.assert_equal(out, self.test_multi_out)

    def test_delta(self):
        delta = self.layer.delta(self.test_out, self.delta_next)
        self.assertEqual(delta.shape, self.delta_this.shape)
        np.testing.assert_equal(delta, self.delta_this)

    def test_delta_multiple(self):
        delta = self.layer.delta(self.test_multi_out, self.delta_next_multi)
        self.assertEqual(delta.shape, self.delta_this_multi.shape)
        np.testing.assert_equal(delta, self.delta_this_multi)


class TestSoftMax(unittest.TestCase):
    def setUp(self) -> None:
        self.test_input = np.array([[1.25, 1.35, 5]])
        self.test_multi_input = np.array([[1.25, 1.35, 5], [1, 2, 3]])
        self.test_out = np.array([[0.02240833, 0.02476504, 0.95282663]])
        self.test_multi_out = np.array([[0.02240833, 0.02476504, 0.95282663], [0.09003057, 0.24472847, 0.66524096]])
        self.layer = SoftmaxLayer("test_softmax")
        self.tolerance = 1e-05

    def test_forward(self):
        out = self.layer.forward(self.test_input)
        self.assertEqual(out.shape, self.test_out.shape)
        np.testing.assert_allclose(out, self.test_out, self.tolerance)

    def test_forward_multiple(self):
        out = self.layer.forward(self.test_multi_input)
        self.assertEqual(out.shape, self.test_multi_out.shape)
        np.testing.assert_allclose(out, self.test_multi_out, self.tolerance)

    def test_delta(self):
        pass

    def test_delta_multiple(self):
        pass


class TestCrossEntropy(unittest.TestCase):
    def setUp(self) -> None:
        self.test_input = np.array([[0.02240833, 0.02476504, 0.95282663]])
        self.true_out = np.array([[0, 0, 1]])
        self.test_multi_input = np.array([[0.02240833, 0.02476504, 0.95282663], [0.09003057, 0.24472847, 0.66524096]])
        self.true_multi_out = np.array([[0, 0, 1], [0, 1, 0]])
        self.test_out = np.array([0.048322312129267])
        self.test_multi_out = np.array([0.048322312129267, 1.407605968])
        self.delta_this = -1 * np.array([[0 / 0.02240833, 0 / 0.02476504, 1 / 0.95282663]])
        self.delta_this_multi = -1 * np.array([[0 / 0.02240833, 0 / 0.02476504, 1 / 0.95282663],
                                               [0 / 0.09003057, 1 / 0.24472847, 0 / 0.66524096]])
        self.layer = LossCrossEntropy("test_crossentropy")

    def test_forward(self):
        out = self.layer.forward(self.test_input, self.true_out)
        self.assertEqual(out.shape, self.test_out.shape)
        np.testing.assert_allclose(out, self.test_out)

    def test_forward_multiple(self):
        out = self.layer.forward(self.test_multi_input, self.true_multi_out)
        self.assertEqual(out.shape, self.test_multi_out.shape)
        np.testing.assert_allclose(out, self.test_multi_out)

    def test_delta(self):
        out = self.layer.delta(self.test_input, self.true_out)
        self.assertEqual(out.shape, self.delta_this.shape)
        np.testing.assert_allclose(out, self.delta_this)

    def test_delta_multiple(self):
        out = self.layer.delta(self.test_multi_input, self.true_multi_out)
        self.assertEqual(out.shape, self.delta_this_multi.shape)
        np.testing.assert_allclose(out, self.delta_this_multi)


class TestSoftmaxCrossEntropy(unittest.TestCase):
    def test_forward(self):
        pass

    def test_forward_multiple(self):
        pass

    def test_delta(self):
        pass

    def test_delta_multiple(self):
        pass
