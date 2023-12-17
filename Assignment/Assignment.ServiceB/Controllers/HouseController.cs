using Microsoft.AspNetCore.Mvc;
using System.Net;

namespace Assignment.ServiceB.Controllers
{
    [ApiController]
    [Route("houses")]
    public class HouseController : ControllerBase
    {
        private readonly ILogger<HouseController> _logger;

        public HouseController(ILogger<HouseController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "Get")]
        [ProducesResponseType((int)HttpStatusCode.OK)]
        public IActionResult Get()
        {
            return Ok();
        }
    }
}
