using Assignment.ServiceA.Services;
using Microsoft.Extensions.Logging;
using NSubstitute;
using System.Net;

namespace Assignment.ServiceA.Tests.Services;

[TestFixture]
public class CoinDeskServiceTests
{
    [Test]
    public async Task GetBitcoinValueInUSDAsync_Success()
    {
        // Arrange
        var logger = Substitute.For<ILogger<CoinDeskService>>();
        var cancellationToken = CancellationToken.None;

        var responseContent = @"{
            ""bpi"": {
                ""USD"": {
                    ""rate_float"": 50000.0
                }
            }
        }";

        var httpMessageHandler = new TestHttpClientHandler(new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent(responseContent)
        });

        var httpClient = new HttpClient(httpMessageHandler)
        {
            BaseAddress = new Uri("https://api.coindesk.com/")
        };
        var coinDeskService = new CoinDeskService(httpClient, logger);

        // Act
        var result = await coinDeskService.GetBitcoinValueInUSDAsync(cancellationToken);

        // Assert
        Assert.That(result, Is.EqualTo(50000.0m));
    }

    [Test]
    public async Task GetBitcoinValueInUSDAsync_Exception_LogsErrorAndThrows()
    {
        // Arrange
        var logger = Substitute.For<ILogger<CoinDeskService>>();
        var cancellationToken = CancellationToken.None;

        var httpMessageHandler = new TestHttpClientHandler(new HttpResponseMessage(HttpStatusCode.InternalServerError));

        var httpClient = new HttpClient(httpMessageHandler)
        {
            BaseAddress = new Uri("https://api.coindesk.com/")
        };
        var coinDeskService = new CoinDeskService(httpClient, logger);

        Assert.ThrowsAsync<HttpRequestException>(() =>
            coinDeskService.GetBitcoinValueInUSDAsync(cancellationToken));

        logger.Received(1).LogError(Arg.Any<Exception>(), "An error occurred when trying to retrieve the current value of bitcoin!");
    }

    [Test]
    public async Task GetBitcoinValueInUSDAsync_Exception_FormatIsDifferent_LogsErrorAndThrows()
    {
        // Arrange
        var logger = Substitute.For<ILogger<CoinDeskService>>();
        var cancellationToken = CancellationToken.None;


        var responseContent = @"{
            ""rate_float"": 50000.0
        }";

        var httpMessageHandler = new TestHttpClientHandler(new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent(responseContent)
        });

        var httpClient = new HttpClient(httpMessageHandler)
        {
            BaseAddress = new Uri("https://api.coindesk.com/")
        };
        var coinDeskService = new CoinDeskService(httpClient, logger);

        Assert.ThrowsAsync<NullReferenceException>(() =>
            coinDeskService.GetBitcoinValueInUSDAsync(cancellationToken));

        logger.Received(1).LogError(Arg.Any<Exception>(), "An error occurred when trying to retrieve the current value of bitcoin!");
    }


    [Test]
    public void Dispose_DisposesHttpClient()
    {
        // Arrange
        var httpClient = Substitute.For<HttpClient>();
        var logger = Substitute.For<ILogger<CoinDeskService>>();

        var coinDeskService = new CoinDeskService(httpClient, logger);

        // Act
        coinDeskService.Dispose();

        // Assert
        httpClient.Received(1).Dispose();
    }
}

public class TestHttpClientHandler : DelegatingHandler
{
    private readonly HttpResponseMessage _response;

    public TestHttpClientHandler(HttpResponseMessage response)
    {
        _response = response ?? throw new ArgumentNullException(nameof(response));
    }

    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        // You can perform custom handling here if needed
        return Task.FromResult(_response);
    }
}