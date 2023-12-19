namespace Assignment.ServiceA.Services
{
    public interface IDataProvider
    {
        public decimal GetCurrentValue();
        public decimal GetAverage();
        public void AddValue(decimal value);
    }
}
