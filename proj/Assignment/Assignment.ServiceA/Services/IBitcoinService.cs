namespace Assignment.ServiceA.Services
{
    public interface IBitcoinService
    {
        Task<decimal> GetBitcoinValueInUSDAsync(CancellationToken cancellationToken);
    }
}
