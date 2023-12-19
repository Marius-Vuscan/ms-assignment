using Assignment.ServiceA.Services;
using Newtonsoft.Json.Linq;

namespace Assignment.ServiceA.Tests.Services;

[TestFixture]
public class MemoryDataProviderTests
{
    [Test]
    public void AddValue_PushesValueOntoStack()
    {
        // Arrange
        var dataProvider = new MemoryDataProvider();
        var value = 42.5M;

        // Act
        dataProvider.AddValue(value);

        // Assert
        Assert.That(dataProvider.GetCurrentValue(), Is.EqualTo(value));
    }

    [Test]
    public void GetCurrentValue_ReturnsDefaultIfStackIsEmpty()
    {
        // Arrange
        var dataProvider = new MemoryDataProvider();

        // Act
        var result = dataProvider.GetCurrentValue();

        // Assert
        Assert.That(result, Is.EqualTo(0));
    }

    [Test]
    public void GetCurrentValue_ReturnsTheLatest()
    {
        // Arrange
        var dataProvider = new MemoryDataProvider();

        for (int i = 1; i <= 15; i++)
        {
            dataProvider.AddValue(i);
        }

        // Act
        var result = dataProvider.GetCurrentValue();

        // Assert
        Assert.That(result, Is.EqualTo(15));
    }

    [Test]
    public void GetAverage_ReturnsAverageOfLastTenMinutes()
    {
        // Arrange
        var dataProvider = new MemoryDataProvider();

        // Add values for the last 15 minutes
        for (int i = 1; i <= 15; i++)
        {
            dataProvider.AddValue(i);
        }

        // Act
        var result = dataProvider.GetAverage();

        // Assert
        Assert.That(result, Is.EqualTo(8));
    }

    [Test]
    public void GetAverage_ReturnsZeroIfNoValuesInLastTenMinutes()
    {
        // Arrange
        var dataProvider = new MemoryDataProvider();

        // Act
        var result = dataProvider.GetAverage();

        // Assert
        Assert.That(result, Is.EqualTo(0));
    }

    [Test]
    public void ConcurrentAccess_AddValuesAndRetrieveCurrentAndAverageValuesConcurrently()
    {
        // Arrange
        var dataProvider = new MemoryDataProvider();
        var tasks = new Task[5];

        // Act
        for (int i = 0; i < tasks.Length; i++)
        {
            tasks[i] = Task.Run(() =>
            {
                for (int j = 1; j <= 15; j++)
                {
                    dataProvider.AddValue(j);
                }
            });
        }

        Task.WaitAll(tasks);

        // Assert
        Assert.That(dataProvider.GetCurrentValue() > 0);
        Assert.That(dataProvider.GetAverage(), Is.EqualTo(8));
    }
}