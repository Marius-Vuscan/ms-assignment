using Assignment.ServiceA.Extensions;
using Assignment.ServiceA.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddBitcoinDependencies();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/bitcoindata", (IDataProvider dataProvider) =>
{
    return Results.Ok(new
    {
        currentValue = dataProvider.GetCurrentValue(),
        averageValue = dataProvider.GetAverage()
    });
})
.WithName("GetBitcoinData")
.WithOpenApi();

app.Run();
