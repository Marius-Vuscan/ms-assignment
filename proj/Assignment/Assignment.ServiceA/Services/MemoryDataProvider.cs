using System.Collections.Concurrent;

namespace Assignment.ServiceA.Services
{
    public class MemoryDataProvider : IDataProvider
    {
        private readonly ConcurrentStack<(DateTime, decimal)> _historicalBitcoinValues = new ConcurrentStack<(DateTime, decimal)>();

        public decimal GetAverage()
        {
            var lastTenMinutes = DateTime.UtcNow.AddMinutes(-10);

            var relevantValues = _historicalBitcoinValues
                .Where(entry => entry.Item1 >= lastTenMinutes)
                .Select(entry => entry.Item2);

            return relevantValues.Any() ? relevantValues.Average() : 0;
        }

        public decimal GetCurrentValue()
        {
            return _historicalBitcoinValues.TryPeek(out var latest) ? latest.Item2 : 0;
        }

        public void AddValue(decimal value)
        {
            _historicalBitcoinValues.Push((DateTime.UtcNow, value));
        }
    }
}
