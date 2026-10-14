using Microsoft.AspNetCore.Mvc;

namespace CodeQuest.Controllers;

public class HomeController : Controller
{
    public IActionResult Index() => View();
    public IActionResult About() => View();
    public IActionResult Topics() => View();
}
