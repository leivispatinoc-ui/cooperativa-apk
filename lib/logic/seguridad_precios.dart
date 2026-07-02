class LogicaPrecios {
  static const double minUSD = 1.0; 
  static const double maxUSD = 20.0;

  static bool esPrecioValido(double precioUSD) {
    return precioUSD >= minUSD && precioUSD <= maxUSD;
  }

  static double calcularPrecioFinal(double km, double base, double kmPrecio, double tasaBCV) {
    double precioUSD = base + (km * kmPrecio);
    if (precioUSD < minUSD) precioUSD = minUSD;
    if (precioUSD > maxUSD) precioUSD = maxUSD;
    return precioUSD * tasaBCV;
  }
}