using Assignment.ServiceA.Services;

namespace Assignment.ServiceA.HostedServices
{
    public class BitcoinBackgroundService : BackgroundService
    {
        private readonly IBitcoinService _bitcoinService;
        private readonly IDataProvider _dataProvider;
        private readonly ILogger<BitcoinBackgroundService> _logger;
        private readonly TimeSpan _interval = TimeSpan.FromSeconds(10);

        public BitcoinBackgroundService(
            IBitcoinService bitcoinService,
            IDataProvider dataProvider,
            ILogger<BitcoinBackgroundService> logger)
        {
            _bitcoinService = bitcoinService;
            _dataProvider = dataProvider;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    var bitcoinPrice = await _bitcoinService.GetBitcoinValueInUSDAsync(stoppingToken);

                    _dataProvider.AddValue(bitcoinPrice);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error when trying to retrieve the bitcoin value and updating the data provider!");
                }

                await Task.Delay(_interval, stoppingToken);
            }
        }
    }
}
