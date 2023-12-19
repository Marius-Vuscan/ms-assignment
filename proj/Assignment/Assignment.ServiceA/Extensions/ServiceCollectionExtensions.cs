using Assignment.ServiceA.HostedServices;
using Assignment.ServiceA.Services;

namespace Assignment.ServiceA.Extensions
{
    public static class ServiceCollectionExtensions
    {
        private const string BaseUrl = "https://api.coindesk.com/";

        public static IServiceCollection AddBitcoinDependencies(this IServiceCollection services)
        {
            services.AddSingleton<IBitcoinService, CoinDeskService>();
            services.AddHttpClient<IBitcoinService, CoinDeskService>(client =>
            {
                client.BaseAddress = new Uri(BaseUrl);
            });
            
            services.AddSingleton<IDataProvider, MemoryDataProvider>();
            services.AddHostedService<BitcoinBackgroundService>();

            return services;
        }
    }
}
