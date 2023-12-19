using Newtonsoft.Json.Linq;

namespace Assignment.ServiceA.Services
{
    public sealed class CoinDeskService : IBitcoinService, IDisposable
    {
        private readonly HttpClient _httpClient;
        private readonly ILogger<CoinDeskService> _logger;

        public CoinDeskService(
            HttpClient httpClient,
            ILogger<CoinDeskService> logger)
        {
            _httpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<decimal> GetBitcoinValueInUSDAsync(CancellationToken cancellationToken)
        {
            try
            {
                string apiUrl = "v1/bpi/currentprice.json";

                using (var response = await _httpClient.GetAsync(apiUrl, cancellationToken))
                {
                    response.EnsureSuccessStatusCode();

                    var json = await response.Content.ReadAsStringAsync(cancellationToken);
                    var data = JObject.Parse(json);

                    var bitcoinValueInUSD = (decimal)data["bpi"]!["USD"]!["rate_float"]!;

                    return bitcoinValueInUSD;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred when trying to retrieve the current value of bitcoin!");
                throw;
            }
        }

        public void Dispose()
        {
            _httpClient.Dispose();
        }
    }
}
