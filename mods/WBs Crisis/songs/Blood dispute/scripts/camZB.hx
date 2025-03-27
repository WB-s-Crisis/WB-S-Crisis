import flixel.util.FlxGradient;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.BitmapData;

/**
 * ⠀⠀⠀⣠⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀
 * ⠀⠀⡜⠁⠀⠈⢢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠋⠷⠶⠱⡄
 * ⠀⢸⣸⣿⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠫⢀⣖⡃⢀⣸⢹
 * ⠀⡇⣿⣿⣶⣤⡀⠀⠀⠙⢆⠀⠀⠀⠀⠀⣠⡪⢀⣤⣾⣿⣿⣿⣿⣸
 * ⠀⡇⠛⠛⠛⢿⣿⣷⣦⣀⠀⣳⣄⠀⢠⣾⠇⣠⣾⣿⣿⣿⣿⣿⣿⣽
 * ⠀⠯⣠⣠⣤⣤⣤⣭⣭⡽⠿⠾⠞⠛⠷⠧⣾⣿⣿⣯⣿⡛⣽⣿⡿⡼
 * ⠀⡇⣿⣿⣿⣿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣮⡛⢿⠃
 * ⠀⣧⣛⣭⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣷⣎⡇
 * ⠀⡸⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣷⣟⡇
 * ⣜⣿⣿⡧⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⣄⠀⠀⠀⠀⠀⣸⣿⡜⡄
 * ⠉⠉⢹⡇⠀⠀⠀⢀⣞⠡⠀⠀⠀⠀⠀⠀⡝⣦⠀⠀⠀⠀⢿⣿⣿⣹
 * ⠀⠀⢸⠁⠀⠀⢠⣏⣨⣉⡃⠀⠀⠀⢀⣜⡉⢉⣇⠀⠀⠀⢹⡄⠀⠀
 * ⠀⠀⡾⠄⠀⠀⢸⣾⢏⡍⡏⠑⠆⠀⢿⣻⣿⣿⣿⠀⠀⢰⠈⡇⠀⠀
 * ⠀⢰⢇⢀⣆⠀⢸⠙⠾⠽⠃⠀⠀⠀⠘⠿⡿⠟⢹⠀⢀⡎⠀⡇⠀⠀
 * ⠀⠘⢺⣻⡺⣦⣫⡀⠀⠀⠀⣄⣀⣀⠀⠀⠀⠀⢜⣠⣾⡙⣆⡇⠀⠀
 * ⠀⠀⠀⠙⢿⡿⡝⠿⢧⡢⣠⣤⣍⣀⣤⡄⢀⣞⣿⡿⣻⣿⠞⠀⠀⠀
 * ⠀⠀⠀⢠⠏⠄⠐⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠳⢤⣉⢳⠀⠀⠀
 * ⢀⡠⠖⠉⠀⠀⣠⠇⣿⡿⣿⡿⢹⣿⣿⣿⣿⣧⣠⡀⠀⠈⠉⢢⡀⠀
 * ⢿⠀⠀⣠⠴⣋⡤⠚⠛⠛⠛⠛⠛⠛⠛⠛⠙⠛⠛⢿⣦⣄⠀⢈⡇⠀
 * ⠈⢓⣤⣵⣾⠁⣀⣀⠤⣤⣀⠀⠀⠀⠀⢀⡤⠶⠤⢌⡹⠿⠷⠻⢤⡀
 * ⢰⠋⠈⠉⠘⠋⠁⠀⠀⠈⠙⠳⢄⣀⡴⠉⠀⠀⠀⠀⠙⠂⠀⠀⢀⡇
 * ⢸⡠⡀⠀⠒⠂⠐⠢⠀⣀⠀⠀⠀⠀⠀⢀⠤⠚⠀⠀⢸⣔⢄⠀⢾⠀
 * ⠀⠑⠸⢿⠀⠀⠀⠀⢈⡗⠭⣖⡒⠒⢊⣱⠀⠀⠀⠀⢨⠟⠂⠚⠋⠀
 * ⠀⠀⠀⠘⠦⣄⣀⣠⠞⠀⠀⠀⠈⠉⠉⠀⠳⠤⠤⡤⠞⠀
 * .......
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠉⢻⣿⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣥⣤⣾⣿⣿⣛⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⣸⣿⣿⠉⢩⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⣴⣿⣿⣇⣀⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⣿⠉⢹⣿⠀⠀⠀⠀⠀⠀⠀⣀⣤⣀⣴⣶⣦⣤⣴⡶⠶⣶⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡿⢿⣿⣠⣼⣿⠀⠀⠀⣠⣴⠶⠟⣿⡍⣿⣁⣀⣀⣈⣉⣶⣶⠀⠀⠀⠈⠙⢿⡶⣦⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⢸⡇⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣇⣼⣿⠉⢸⣿⠀⢀⣠⣿⣡⣤⣴⣾⣿⣿⣏⣉⣹⡟⠙⠻⣿⠷⣦⣤⣀⠀⣸⣿⠀⠀⠉⠙⢿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠛⢻⣦⣸⣿⠏⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡋⢿⣆⢸⣿⣼⢟⣿⣿⣻⣵⣿⣿⡆⠈⠙⣛⣻⣿⣆⠀⠸⠃⢠⣿⠛⠻⣿⣷⣤⡀⠀⠀⠀⠹⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣧⣀⠀⣽⣿⢿⣦⣀⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧⣾⢿⣼⠟⣡⣿⡉⠁⠀⣀⣬⣿⠿⠛⠛⠛⠉⠉⠛⠻⠷⢶⣶⣥⣶⣶⣽⣧⠈⠻⣷⡄⢠⣿⣏⠛⢷⣆⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⠈⢿⣿⣿⠁⠀⢨⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⣿⣈⢻⡿⢛⣿⣿⡷⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣧⣴⡾⣿⣿⡿⠋⠀⠈⣿⡄⠀⠀⠀⠀⠀⠀⣴⣿⡄⣠⣾⠏⠙⢷⣴⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⠙⣻⣿⡿⠛⠉⠁⠀⠀⠀⠀⠀⠀⣴⡿⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠈⠻⣿⣁⠀⣿⠉⢿⣆⠀⠀⢻⡇⠀⠀⠀⠀⣤⣾⠏⠹⣿⣿⣿⣤⣴⠿⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣿⣶⠾⠛⢁⣠⠀⠀⠀⠀⠀⠀⠀⢀⣾⠏⠀⠀⠀⠀⠀⠀⢰⡿⠀⠀⠀⠀⠀⠀⠈⠛⣷⣿⡀⠀⠹⣧⣠⣾⣿⣄⣠⣴⡾⠛⢿⣆⣠⣿⠿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠉⢹⣿⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⢠⡾⠋⠀⠀⠀⠀⠀⠀⢰⡿⠁⢀⣄⠀⠀⠀⠀⠀⠀⢸⣿⠛⠷⣦⣿⣿⠛⠙⢿⣿⣧⡀⢀⣘⣿⡿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⢠⣿⠋⠀⠀⠀⠀⠀⠀⣠⣿⡇⠀⢰⣿⡆⠀⠀⣰⡿⠁⠀⣸⣿⠀⠀⠀⠀⠀⠀⠀⣿⣄⣠⣿⠈⢿⡆⠀⢸⣧⣽⣿⠟⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡇⢀⣿⠃⠀⠀⠀⣤⡀⢀⣾⠟⣽⡇⣰⡟⣿⡇⣠⣾⠟⠀⣴⣦⣿⣿⡀⠀⠀⠀⠀⠀⠀⢻⡏⣿⡇⠀⢸⡇⠀⣸⡏⢰⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⢧⡿⢣⣄⠀⠀⣼⡿⢀⣾⠏⠀⣿⣿⡟⠁⣿⣿⠟⠁⢀⣾⣿⣿⡏⣿⡇⠀⢀⣤⠀⠀⠀⣸⡇⣿⡿⠗⢸⡇⠀⢹⡇⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡿⠃⢸⡿⠀⣰⣿⣡⣿⠋⠀⢸⣿⡿⠃⠘⣿⡇⠀⢀⣾⢏⣿⡿⠀⢹⣷⠀⢸⣿⡄⠀⠀⢿⣷⠙⣿⠀⢸⡇⢠⣿⠃⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⣡⣤⢸⣇⣴⣿⣿⣿⣅⣀⡀⠸⣿⣀⡀⢸⣿⠀⢀⣾⠏⢈⣿⠿⠂⠀⣿⡄⢸⣿⣷⠀⠀⣼⣿⡆⣿⣇⣿⠁⢸⡇⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⢟⣴⣿⣿⢸⣿⠏⢸⡏⢿⣏⠛⠛⣷⣿⣿⣷⣤⣿⣀⣾⠏⠀⣼⣿⡆⠀⠀⠹⣷⣼⡏⣿⡆⠀⠻⣿⣷⣸⣿⣧⣶⣿⡇⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢶⣶⣶⣤⡀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣷⡾⠋⢸⣿⠘⠋⠀⢸⡇⠈⠿⣦⣿⣇⣻⣳⣾⡟⣿⡿⠋⠀⠘⣿⡝⠛⠛⢿⣾⣿⣿⣷⣾⣿⡆⠀⢻⣿⣿⣿⣿⣿⣿⡇⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⣻⣷⢛⣯⣼⣿⠛⣦⣀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡿⠟⣿⡇⠀⢸⣿⠀⠀⠀⣼⡇⠀⠀⠀⠉⠉⠉⠉⠁⠀⠛⠁⠀⠀⠀⠘⢿⣦⣐⣿⣤⣿⣷⡿⢛⣿⣿⡀⢸⣿⣿⣿⣽⡟⢹⡇⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⢶⣿⡿⢿⣿⢿⣿⣿⣷⣿⡀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠃⠀⢸⣿⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠀⠀⣼⡏⠹⣷⡀⣿⡿⣿⡟⠀⢸⡷⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣿⣿⣾⣹⠈⣸⡀⣹⣯⣟⣯⡇
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡏⠀⠀⣾⠇⣤⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠀⠀⢹⣿⣿⣧⠹⠿⠀⣾⡇⠀⣹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⢠⣿⣷⡹⣷⣼⡏⠁
 * ⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠇⠀⣼⡟⣴⣿⠀⠀⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡄⠀⠀⠀⠀⢠⣿⠁⠀⢠⣿⣿⠿⠟⠀⠀⢸⣿⠀⠀⢹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢻⣿⣿⣿⣏⣿⣿⠋⠀⠀
 * ⠀⠀⠀⠀⠀⠀⣿⣏⠉⠉⠉⠉⠛⠉⠛⠻⢷⣦⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⢀⣾⣿⣾⠿⣿⠀⢀⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠶⠶⠶⠶⠶⠾⠿⠛⠁⠀⠀⠀⢠⣿⠏⠀⣠⣿⠋⠁⠀⠀⠀⠀⢸⣿⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢾⣿⡿⣿⡿⣿⣿⠀⠀⠀
 * ⠀⢀⣠⣤⣤⣴⣾⣿⡷⠶⠶⠂⠀⠀⢀⣴⠾⠉⠉⠛⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠿⠿⢻⣿⢀⣿⠀⣸⡟⠙⠻⣿⣿⣷⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣿⡟⠀⣰⣿⡇⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠸⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣼⣿⠻⣦⣴⣿⡏⠀⠀⠀
 * ⣴⡟⢉⣩⣶⡿⣂⣀⠀⠀⠀⠀⣶⡄⠘⠟⠀⠀⠀⠀⠀⠹⣷⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⣼⡇⢸⣿⢀⣿⠁⠀⠀⠹⣿⣿⣯⠙⠛⣿⣶⣶⣶⣶⠶⣶⣶⣶⠿⠟⠉⣹⡿⠁⢠⣿⠻⣿⡄⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⠟⢄⠙⢛⡏⠀⠀⠀⠀
 * ⠛⣿⠟⢋⣵⣿⠟⣁⣤⣴⡦⠀⠀⠀⣀⢀⣀⣀⣠⣴⠄⠀⢻⣧⠀⠀⠀⠀⠀⣾⡏⠀⠀⢰⣿⣱⣿⣿⣼⡏⠀⠀⢀⣴⡿⠻⣿⣦⣼⠟⢿⣧⣤⣴⡶⠿⠛⢻⣶⣶⣶⣿⣿⢠⣿⣿⣄⣸⡇⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⢻⣧⣀⣴⡿⠿⠿⠿⠿⣶⣶⡶⠿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠈⠒⠮⠭⠟⠀⠀⠀⠀⠀
 * ⠀⣿⣶⣿⣿⣷⠿⢻⣿⢋⣴⡾⠛⠛⠛⠻⣿⡋⠉⠀⠀⠀⠀⢿⣇⠀⠀⠀⣼⡟⠀⠀⠀⣸⣿⡟⠘⠿⠏⠰⢷⣶⡿⠋⠀⠀⣠⣿⣋⣴⣬⣉⠉⠁⠀⠀⠀⣼⡟⣹⣿⠋⣿⣿⣯⣼⡟⢻⣷⡀⠀⠀⠀⠀⠸⣿⡄⠀⠀⢈⣿⡿⠉⢡⣄⠀⠀⠀⠰⣶⣶⣿⡛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠸⠿⠟⠁⠀⠀⠀⠀⠀⠹⣷⡀⠀⠀⠀⠀⠘⣿⡄⠀⣰⡿⠁⠀⠀⢠⣿⠏⣴⡿⠂⠀⢀⣾⠋⠀⠀⠀⣰⣿⠿⣿⡇⠀⣀⣿⡇⠀⢀⣾⠟⣼⣿⠃⠀⣿⣿⣏⠉⠀⠀⢻⣧⠀⠀⠀⠀⠀⢻⣧⢠⣾⡿⠋⠀⠀⠈⢻⣧⣀⣀⣀⠀⠉⠙⠻⢿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⠀⠀⠀⠀⠀⢻⣧⢠⣿⠃⠀⠀⠀⣿⡇⢸⣿⠀⠀⢠⣿⠃⠀⠀⠀⣴⡿⠁⣠⣿⣄⣼⠟⠻⣷⣾⣿⠋⠀⢸⣿⠀⠀⠀⢸⣿⠀⠀⠀⠈⢿⣆⠀⠀⠀⠀⠀⢿⣿⠏⠀⢶⣦⣄⠀⠀⠻⣿⠉⠉⠀⠀⣤⣀⠈⠻⢿⣿⠷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠘⣿⣿⠃⠀⠀⢀⣼⡟⠀⠀⢻⣆⣠⣿⠃⠀⠀⢀⣾⠟⢀⣼⡿⠛⣻⡏⠀⠀⢀⣿⠃⠀⠀⣿⣿⠀⠀⣴⡟⠁⠀⠀⠀⠀⠈⣿⡇⠀⠀⠀⣠⣿⠋⠀⠀⠀⠈⣻⣿⣷⣦⣄⡀⠀⣶⣤⡻⣿⣿⣶⣼⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⠀⠀⠀⠀⠀⠀⢻⣿⠀⠀⢀⣾⠏⠀⠐⣶⣬⣿⠟⠀⠀⠀⠀⣼⣿⣴⡿⠋⠀⢠⣿⣇⣀⣀⣼⡟⠀⠀⠀⢹⣿⠀⣠⣿⣷⡷⠀⠀⠀⠀⠀⢸⣷⠀⢀⣴⡿⠁⠀⠀⠀⢀⣾⢿⣿⠀⠈⠙⢿⣦⣸⣿⢿⣮⣻⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⠀⠀⠀⠀⠀⣿⣷⡾⠿⠟⠀⢸⣶⡿⠟⠁⠀⠀⠀⠀⠀⣰⣿⠋⠀⠀⢠⣿⠏⠉⠙⠋⠉⠀⠀⠀⠀⢸⣿⣠⣿⠀⣿⠃⠀⠀⠀⠀⠀⠠⣿⣧⣿⠋⠀⠀⠀⠀⠀⣾⠏⢸⣿⠀⠀⠀⠀⠙⠛⠋⠀⠉⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣇⠀⠀⠀⠀⠀⠀⠘⣷⡄⠀⠀⣠⣿⠋⠀⠀⠀⠀⠀⠀⠀⣰⣿⠁⠀⠀⠀⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣯⠁⣼⡏⠀⠀⠀⠀⠀⠀⠀⢸⣿⠇⠀⠀⠀⠀⠀⣼⡿⠀⠀⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠘⣿⣄⣾⡟⠁⠀⠀⠀⠀⠀⠀⠀⢠⣿⠃⠀⠀⠀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣦⣿⠀⠀⠀⠀⠀⠀⠀⣴⡟⠃⠀⠀⠀⠀⠀⣰⡿⠁⠀⠀⠘⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢀⡘⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⢀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡏⠀⠀⠀⠀⠀⢀⣼⠏⠀⠀⠀⠀⠀⠀⢠⣿⡇⠘⠀⠀⠀⢸⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣀⣤⡀⠀⢀⣀⣠⡿⢻⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⢀⣾⣏⣀⠀⠀⠀⠀⠀⠀⣼⢿⣇⠀⠀⠀⠀⠀⢻⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⠛⠿⠶⠟⠛⠋⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠿⢿⣶⣤⣀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠀⠀⠀⠀⢠⣿⠛⢻⣿⣠⡀⠀⠀⠀⣰⡿⠘⣿⡄⠄⠀⠀⠀⠈⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠛⣿⡆⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⡀⠀⠀⢠⣿⠃⠀⠘⠻⢻⣷⣦⡀⢠⣿⠃⠀⢹⣿⠀⠀⠀⠀⣠⣼⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠃⠀⢹⣿⡀⠀⠀⠀⠀⠀⠀⠘⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⡿⠿⣶⣴⣾⣏⠀⠀⠀⠀⠀⠀⠙⢿⣿⡏⠀⠀⠈⢿⣧⠈⠂⠀⢹⣿⡟⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠇⠀⠀⠀⢻⣷⣄⣀⣀⣀⣀⣠⣶⠟⠻⣿⣦⡀⠀⡀⠀⠀⠀⠀⠻⣿⣦⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⢿⣿⠃⠀⠙⠋⠹⣿⡀⠀⠀⠀⠀⠀⣠⣾⠟⠀⠀⠀⠀⠈⣿⣇⠀⠀⢸⣿⣿⡘⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠏⠀⠀⠀⠀⠀⣸⡿⠛⠛⠛⠛⠉⠁⠀⠀⠈⠛⠿⣿⣿⡆⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠿⢿⣶⣶⣶⣦⣶⣶⣾⠟⠁⣼⡟⠀⠀⠀⠀⠀⢿⣧⡀⠀⢀⣠⣶⡿⠁⠀⠀⠀⠀⠀⠀⠸⣿⡀⠀⠀⢿⣿⣧⠸⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣾⠆⠀⠀⠀⢠⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⠙⠛⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣧⠀⠀⠸⣿⣿⣇⢹⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡿⢸⣿⢠⡀⠀⠀⣼⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⣤⣀⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡀⠀⠀⣿⡏⣿⣎⢿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠇⣿⣿⢸⣇⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠿⢿⣶⣶⣤⣄⣀⡀⠀⠀⠀⠀⠈⠙⠻⣿⣶⣶⣶⣶⣀⣠⣤⣾⠿⠉⠉⠉⠙⠛⠻⢿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⠀⠀⢸⣿⠘⣿⡞⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⢰⣿⣿⢨⡅⠀⢸⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡄⣀⣤⣾⣯⣍⡙⠛⠿⠿⠿⠷⠿⠿⠿⠿⠿⠿⠿⠿⢟⣛⣻⣿⣷⣶⣶⣄⠀⠀⠀⠀⠀⠙⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠘⣿⡆⢹⣷⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⢸⣿⣿⠀⠀⠀⢸⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⠿⠟⠉⠉⠛⠿⢿⣶⣶⣶⣤⣤⣤⣤⣤⣴⣶⣶⣿⣿⡿⠋⠁⠀⠀⠈⠿⣷⣤⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣇⠀⠀⣿⣇⢸⣿⠸⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣸⣿⣿⣇⠀⠀⢘⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⢩⣴⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠈⢻⣷⣄⠀⢰⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡀⠀⢸⣿⢸⣿⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⠹⣿⡄⠀⠐⣿⡇⠀⠀⠀⠀⠀⠀⠀⣼⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣾⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣶⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⣿⣽⣿⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⡿⠀⠹⣿⡀⠀⢻⣿⠀⠀⠀⠀⠀⠀⢸⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠛⠛⠓⠒⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⠤⠟⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠒⠚⠛⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠛⠛⠒⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
 * .......
 * 啥成分我不说⠀⠀⠀⠀
 */

var black:FlxSprite;
var killingAura:FlxSprite;
var fwMovies:FlxSpriteGroup;
var camMovie:FlxCamera;

var originIndex:Dynamic = {
	dad: -1,
	pico: -1,
	bf: -1
};

var pico:Character = strumLines.members[1].characters[0];
var bf:Character = strumLines.members[2].characters[0];

//取消切换镜头
var camCancelled:Bool = false;
var defaultGoodCamZoom = 0.95;
var goodZoomLerp = 0.05;
var goodCamZooming:Bool = false;
var defaultGoodHUDZoom = 1;
var goodZoomHUDLerp = 0.05;
var bendiMode:Bool = false;
var startKilling:Bool = false;
var anotherKilling:Bool = false;
function create() {
	killingAura = new FlxSprite();
	//那个渐变的，dddd
	var bitmapData:BitmapData = new BitmapData(FlxG.width, FlxG.height, true, 0x00000000);
	for(i in 1...5) {
		bitmapData.draw(FlxGradient.createGradientBitmapData(FlxG.width, FlxG.height, [0xFFFF0000, 0x00000000, 0x00000000, 0x00000000, 0x00000000], 1, i * 90));
	}
	var graphic = FlxG.bitmap.add(bitmapData);
	killingAura.loadGraphic(graphic);
	killingAura.cameras = [camOther];
	killingAura.alpha = 0;
	//killingAura.visible = false;
	add(killingAura);
}

function postCreate() {
	camMovie = new FlxCamera();
	camMovie.bgColor = 0;
	cameraInsert(camMovie, 1, false);

	black = new FlxSprite(-750, -350).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
	black.scrollFactor.set();
	black.cameras = [camGame];
	add(black);
	
	defaultGoodCamZoom = camGame.zoom;
	
	fwMovies = new FlxSpriteGroup();
	setupMovies(fwMovies);
	fwMovies.cameras = [camMovie];
	fwMovies.scrollFactor.set();
	insert(0, fwMovies);
	shoufuTaiwang(0.001);
	
	camHUD.alpha = 0;
	
	originIndex.dad = members.indexOf(dad);
	originIndex.pico = members.indexOf(pico);
	originIndex.bf = members.indexOf(bf);
}

function onStartSong() {
	FlxTween.tween(camHUD, {alpha: 1}, Conductor.crochet * 28 / 1000);
	FlxTween.tween(black, {alpha: 0}, Conductor.crochet * 28 / 1000);
	qinlveTaiwang(Conductor.crochet * 16 / 1000);
	
	camZooming = false;
}

var preZoom:Float = 0;
var realCamZooming:Bool = false;
function stepHit(step:Int) {
	switch(step) {
		case 0:
			camCancelled = true;
			goodCamZooming = true;
			camFollow.setPosition(650, 450);
			goodZoomLerp = 0.001;
			defaultGoodCamZoom = camGame.zoom - 0.4;
			preZoom = camGame.zoom - 0.2;
			camGame.followLerp = 1;
		case 32:
			camGame.flash(0xFF000000, 0.5);
			beatCameraZoom(0.04, 0.03);
		case 64:
			camGame.flash(0xFF000000, 0.5);
			beatCameraZoom(0.04, 0.03);
		case 96:
			camGame.flash(0xFF000000, 0.5);
			beatCameraZoom(0.04, 0.03);
		case 114:
			FlxTween.tween(camFollow, {x: camFollow.x - 250, y: camFollow.y + 175}, Conductor.crochet * 3 / 1000, {ease: FlxEase.circInOut});
			goodZoomLerp = 0.025;
			defaultGoodCamZoom += 0.45;
		case 128:
			shoufuTaiwang(Conductor.stepCrochet / 1000);
			camCancelled = false;
			realCamZooming = true;
			goodZoomLerp = 0.05;
			goodCamZooming = false;
			camGame.flash(0xFF000000, 1);
			camGame.followLerp = 0.04;
		case 143:
			defaultCamZoom += 0.2;
			camGameZoomLerp = 0.35;
		case 146 | 150 | 154 | 158:
			defaultCamZoom -= 0.2 / 4;
		case 160:
			camGameZoomLerp = 0.05;
		case 202:
			camGameZoomLerp = 0.35;
			defaultCamZoom += 0.05;
		case 207:
			defaultCamZoom += 0.05;
		case 212:
			defaultCamZoom += 0.05;
		case 216:
			defaultCamZoom += 0.05;
		case 220:
			defaultCamZoom -= 0.05 * 5;
			camGameZoomLerp = 0.25;
		case 222:
			defaultCamZoom += 0.05 * 2/5;
		case 223:
			defaultCamZoom += 0.05 * 2/5;
		case 224:
			camGameZoomLerp = 0.05;
		case 254:
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
		case 290:
			camGameZoomLerp = 0.05;
			camCancelled = false;
			goodCamZooming = false;
			realCamZooming = true;
			curCameraTarget = 1;
		case 320:
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
		case 352:
			goodCamZooming = false;
			camCancelled = false;
			realCamZooming = true;
			curCameraTarget = 1;
		case 368:
			camCancelled = true;
			realCamZooming = false;
			camGame.followLerp = 1;
			camGame.flash(0xFF000000, 0.5);
			camGame.zoom = 0.95;
			camFollow.setPosition(150, 500);
			follow = false;
		case 371:
			camGame.zoom += 0.05;
			camGame.flash(0xFF000000, 0.5);
		case 374:
			camGame.flash(0xFF000000, 0.35);
			FlxTween.tween(camGame, {zoom: camGame.zoom + 0.25}, Conductor.stepCrochet * 10 / 1000);
		case 384:
			black.alpha = 1;
			
			remove(bf);
			remove(dad);
			insert(members.indexOf(black) + 1, dad);
			insert(members.indexOf(black) + 1, bf);
			dad.colorTransform.color = 0xFFFF0000;
			camFollow.setPosition(650, 550);
			camGame.zoom = preZoom;
			bf.colorTransform.color = bf.iconColor;
			
			camHUD.alpha = 0;
			anotherKilling = true;
			for(obj in [dad, bf, pico]) {
				obj.colorTransform.alphaMultiplier = 0;
			}
		case 506:
			camHUD.alpha = 1;
			timeGroup.alpha = 0;
			TBHealthBar.alpha = 0;
			healthBar.alpha = 0;
			strumLines.forEachAlive((strumLine:StrumLine) -> {
				strumLine.forEach(function(obj:Strum) {
					obj.alpha = 0;
				});
			});
			for(items in [animationIconP1, animationIconP2, animationIconP3, missesTxt, accuracyTxt, scoreTxt]) {
				items.alpha = 0;
			}
			
			anotherKilling = false;
			remove(bf);
			remove(dad);
			insert(originIndex.dad, dad);
			insert(originIndex.bf, bf);
			dad.colorTransform = null;
			dad.updateColorTransform();
			bf.colorTransform = null;
			bf.updateColorTransform();
			pico.colorTransform = null;
			pico.updateColorTransform();
			
			strumLines.members[1].forEach(function(obj:Strum) {
				FlxTween.tween(obj, {alpha: 1}, Conductor.stepCrochet * 4 / 1000, {ease: FlxEase.quadIn});
			});
			qinlveTaiwang(Conductor.crochet * 2 / 1000);
		case 512:
			realCamZooming = false;
			goodCamZooming = true;
			camCancelled = true;
			
			FlxTween.tween(black, {alpha: 0}, Conductor.stepCrochet * 78 / 1000);
			for(items in [animationIconP1, animationIconP2, animationIconP3, missesTxt, accuracyTxt, scoreTxt, TBHealthBar, timeGroup, healthBar]) {
				FlxTween.tween(items, {alpha: 1}, Conductor.stepCrochet * 78 / 1000);
			}
			camFollow.setPosition(1150, 700);
			defaultGoodCamZoom = 1.25;
			FlxTween.tween(camFollow, {x: camFollow.x + 165}, Conductor.crochet * 32 / 1000);
		case 640:
			shoufuTaiwang(Conductor.crochet * 2 / 1000);
			camGame.followLerp = 0.04;
			follow = true;
			defaultGoodCamZoom += 0.2;
			defaultGoodZoomLerp = 0.04;
		case 646:
			defaultGoodCamZoom -= 0.2;
			defaultGoodZoomLerp = 0.01;
		case 656:
			defaultGoodCamZoom += 0.1;
			defaultGoodZoomLerp = 0.05;
		case 660:
			defaultGoodCamZoom -= 0.05;
			defaultGoodZoomLerp = 0.4;
		case 662 | 663 | 664 | 666 | 667 | 668 | 669:
			defaultGoodCamZoom -= 0.05;
		case 671:
			defaultGoodCamZoom += 0.5;
			defaultGoodZoomLerp = 0.05;
		case 674:
			defaultGoodCamZoom -= 0.2;
		case 682 | 683 | 684 | 685 | 686:
			defaultGoodCamZoom -= 0.3 / 5;
			defaultGoodZoomLerp = 0.4;
		case 688:
			defaultGoodCamZoom += 0.1;
			defaultGoodZoomLerp = 0.06;
		case 696:
			defaultGoodCamZoom += 0.1;
		case 698 | 700:
			defaultGoodCamZoom += 0.05;
			defaultGoodZoomLerp = 0.4;
		case 799 | 701:
			defaultGoodCamZoom -= 0.05;
		case 704:
			//beatCameraZoom(0.08, 0.08);
			defaultGoodZoomLerp = 0.03;
		case 705:
			defaultGoodCamZoom -= 0.2;
			camFollow.setPosition(camFollow.x - 40, camFollow.y - 15);
		case 720:
			defaultGoodCamZoom += 0.5;
		case 734 | 736 | 737 | 738 | 739 | 740 | 742 | 743 | 744 | 746 | 747 | 748 | 749 | 750:
			defaultGoodCamZoom -= 0.7 / 14;
			defaultGoodZoomLerp = 0.5;
		case 752 | 753 | 754 | 755 | 758 | 759 | 760 | 762 | 764 | 765:
			defaultGoodCamZoom += 0.5 / 6;
		case 768:
			defaultGoodZoomLerp = 0.05;
			//followPoint.set(followPoint.x * 1.5, followPoint.y * 1.5);
			camCancelled = false;
			goodCamZooming = false;
			realCamZooming = true;
		case 800:
			camHUD.flash(0xFF000000, 0.35);
			strumLines.members[0].forEach(function(obj:Strum) {
				obj.alpha = 1;
			});
			bendiMode = true;
		case 816:
			defaultCamZoom += 0.06;
			camGameZoomLerp = 0.45;
		case 819:
			defaultCamZoom += 0.06;
		case 821:
			defaultCamZoom -= 0.06;
		case 822:
			defaultCamZoom -= 0.06;
		case 824:
			defaultCamZoom -= 0.03;
		case 827:
			defaultCamZoom -= 0.01;
		case 829:
			defaultCamZoom += 0.04;
		case 830:
			camGameZoomLerp = 0.05;
		case 885 | 886 | 887 | 888:
			beatCameraZoom(0.05, 0.005);
		case 890:
			camGameZoomLerp = 0.45;
			defaultCamZoom += 0.045;
		case 891:
			defaultCamZoom -= 0.045 / 2;
		case 892:
			defaultCamZoom -= 0.045 / 2;
			camGameZoomLerp = 0.05;
		case 920 | 921 | 922 | 923 | 924 | 925 | 926:
			beatCameraZoom(0.1 / 7, 0.05 / 7);
		case 944 | 945:
			camGameZoomLerp = 0.45;
			defaultCamZoom += 0.075 / 2;
		case 946:
			defaultCamZoom -= 0.125;
		case 948:
			defaultCamZoom += 0.05;
		case 1024:
			bendiMode = false;
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
		case 1042:
			camGameZoomLerp = 0.05;
			camCancelled = false;
			goodCamZooming = false;
			realCamZooming = true;
		case 1055:
			camCancelled = true;
		case 1058:
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
		case 1072:
			camGameZoomLerp = 0.05;
			camCancelled = false;
			goodCamZooming = false;
			realCamZooming = true;
		case 1120:
			curCameraTarget = 0;
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
		case 1152:
			camGameZoomLerp = 0.05;
			camCancelled = false;
			goodCamZooming = false;
			realCamZooming = true;
		case 1166:
			defaultCamZoom += 0.075;
			camGameZoomLerp = 0.45;
		case 1168:
			defaultCamZoom += 0.075;
		case 1172 | 1174 | 1178 | 1180:
			defaultCamZoom -= 0.075 / 2;
		case 1184:
			beatCameraZoom(0.075, 0);
			camGameZoomLerp = 0.05;
		case 1198:
			camGameZoomLerp = 0.45;
			defaultCamZoom += 0.05;
		case 1200:
			defaultCamZoom += 0.05;
		case 1204 | 1206:
			defaultCamZoom += 0.05;
		case 1210:
			defaultCamZoom -= 0.03;
		case 1212:
			defaultCamZoom -= 0.07;
		case 1216:
			camGameZoomLerp = 0.05;
		case 1228:
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
			camGame.followLerp = 0.05;
		case 1235:
			camGameZoomLerp = 0.05;
			camCancelled = false;
			goodCamZooming = false;
			realCamZooming = true;
		case 1248:
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
			camGame.followLerp = 0.05;
		case 1280:
			goodCamZooming = false;
			FlxTween.tween(camGame, {zoom: camGame.zoom + 1.25}, Conductor.crochet * 4 / 1000);
			camFollow.setPosition(1100, 620);
			camGame.followLerp = 0.02;
			FlxTween.tween(black, {alpha: 1}, Conductor.crochet * 4 / 1000);
			FlxTween.tween(camHUD, {alpha: 0}, Conductor.crochet * 4 / 1000, {onComplete: function(_) {
				anotherKilling = true;
				for(obj in [dad, bf, pico]) {
					obj.colorTransform.alphaMultiplier = 0;
				}
				
				remove(pico);
				remove(dad);
				insert(members.indexOf(black) + 1, dad);
				insert(members.indexOf(black) + 1, pico);
				dad.colorTransform.color = 0xFFFF0000;
				camFollow.setPosition(650, 550);
				camGame.zoom = preZoom;
				pico.colorTransform.color = pico.iconColor;
			}});
		case 1397:
			anotherKilling = false;
			
			remove(pico);
			remove(dad);
			insert(originIndex.dad, dad);
			insert(originIndex.pico, pico);
			dad.colorTransform = null;
			dad.updateColorTransform();
			bf.colorTransform = null;
			bf.updateColorTransform();
			pico.colorTransform = null;
			pico.updateColorTransform();
			
			camHUD.alpha = 1;
			timeGroup.alpha = 0;
			TBHealthBar.alpha = 0;
			healthBar.alpha = 0;
			strumLines.forEachAlive((strumLine:StrumLine) -> {
				strumLine.forEach(function(obj:Strum) {
					obj.alpha = 0;
				});
			});
			for(items in [animationIconP1, animationIconP2, animationIconP3, missesTxt, accuracyTxt, scoreTxt]) {
				items.alpha = 0;
			}
			
			strumLines.members[0].forEach(function(obj:Strum) {
				FlxTween.tween(obj, {alpha: 1}, Conductor.stepCrochet * 4 / 1000, {ease: FlxEase.quadIn});
			});
		case 1404:
			FlxTween.tween(black, {alpha: 0}, Conductor.stepCrochet * 32 / 1000);
			for(items in [animationIconP1, animationIconP2, animationIconP3, missesTxt, accuracyTxt, scoreTxt, TBHealthBar, timeGroup, healthBar]) {
				FlxTween.tween(items, {alpha: 1}, Conductor.stepCrochet * 32 / 1000);
			}
			strumLines.members[1].forEach(function(obj:Strum) {
				FlxTween.tween(obj, {alpha: 1}, Conductor.stepCrochet * 32 / 1000);
			});
			realCamZooming = true;
			camCancelled = false;
			camGame.followLerp = 0.04;
			goodCamZooming = false;
		case 1468:
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
			camGame.followLerp = 0.05;
		case 1504:
			camCancelled = true;
			goodCamZooming = false;
			camGame.followLerp = 1;
			camFollow.setPosition(1050, 700);
			camGame.zoom = 1.15;
			FlxTween.tween(camGame, {zoom: camGame.zoom - 0.1}, Conductor.crochet * 2 / 1000);
			camGame.flash(0xFF000000, Conductor.crochet / 1000);
		case 1512:
			camFollow.setPosition(250, 500);
			camGame.zoom = 1.05;
			FlxTween.tween(camGame, {zoom: camGame.zoom - 0.1}, Conductor.crochet * 2 / 1000);
			camGame.flash(0xFF000000, Conductor.crochet / 1000);
		case 1520:
			camFollow.setPosition(1050, 700);
			camGame.zoom = 1.15;
			FlxTween.tween(camGame, {zoom: camGame.zoom - 0.1}, Conductor.crochet * 2 / 1000);
			camGame.flash(0xFF000000, Conductor.crochet / 1000);
		case 1526:
			camFollow.setPosition(250, 500);
			camGame.zoom = 1.15;
			FlxTween.tween(camGame, {zoom: camGame.zoom - 0.1}, Conductor.crochet * 2 / 1000);
			camGame.flash(0xFF000000, Conductor.crochet / 1000);
		case 1532:
			camFollow.setPosition(1150, 700);
			camGame.zoom = 1.05;
			FlxTween.tween(camGame, {zoom: camGame.zoom - 0.1}, Conductor.crochet * 2 / 1000);
			camGame.flash(0xFF000000, Conductor.crochet / 1000);
		case 1536:
			camGame.followLerp = 0.05;
			//camGame.flash(0xFF000000, Conductor.crochet / 1000);
			bendiMode = true;
			startKilling = true;
			camGame.flash(0xFF000000, 0.314);
			camGameZoomLerp = 0.05;
			camCancelled = false;
			goodCamZooming = false;
			realCamZooming = true;
		case 1806:
			//o
		case 1920:
			realCamZooming = false;
			goodCamZooming = true;
			defaultGoodCamZoom = preZoom;
			camCancelled = true;
			camFollow.setPosition(650, 450);
			camGame.followLerp = 0.05;
		case 1984:
			//3
		case 2016:
			camHUD.flash(0xFF000000, 0.25);
			follow = false;
			camCancelled = true;
			goodCamZooming = false;
			realCamZooming = false;
			camGame.followLerp = 1;
			bendiMode = false;
			startKilling = false;
			camGame.zoom = 0.95;
			camFollow.setPosition(250, 500);
			FlxTween.tween(camGame, {zoom: camGame.zoom + 0.11}, Conductor.stepCrochet * 8 / 1000, {ease: FlxEase.quadInOut});
		case 2024:
			camGame.flash(0xFF000000, 0.25);
			camFollow.setPosition(1050, 700);
			camGame.zoom = 1.05;
			FlxTween.tween(camGame, {zoom: camGame.zoom + 0.11}, Conductor.stepCrochet * 8 / 1000, {ease: FlxEase.quadInOut});
		case 2032:
			camGame.flash(0xFF000000, 0.25);
			camFollow.setPosition(350, 500);
			camGame.zoom = 0.95;
			FlxTween.tween(camGame, {zoom: camGame.zoom + 0.11}, Conductor.stepCrochet * 8 / 1000, {ease: FlxEase.quadInOut});
		case 2040:
			black.alpha = 1;
		case 2048:
			black.alpha = 0;
			camGame.fade(0xFF000000, 0.35);
			camFollow.setPosition(650, 450);
			camGame.zoom = preZoom;
			FlxTween.tween(black, {alpha: 1}, Conductor.crochet * 4 / 1000, {startDelay: Conductor.stepCrochet * 4 / 1000, onComplete: function(_) {
				FlxTween.tween(camHUD, {alpha: 0}, Conductor.stepCrochet * 8 / 1000);
			}});
			goodCamZooming = false;
			FlxTween.tween(camGame, {zoom: camGame.zoom + 1}, Conductor.crochet * 8 / 1000, {ease: FlxEase.quadOut});
		default: {}
	}
}

function beatHit(beat:Int) {
	if(bendiMode) {
		beatCameraZoom(0.05, 0.089);
		chromatic.aberration -= 0.1;
	}
	
	if(startKilling) {
		ruozhiFuck(0.5);
	}
}

function measureHit(measure:Int) {
	if(anotherKilling) {
		if(measure % 2 == 0) {
			ruozhiFuck(0.65);
			
			if(measure >= 26 && measure != 80) {
				for(obj in [dad, bf, pico]) {
					obj.colorTransform.alphaMultiplier = 1;
					FlxTween.tween(obj.colorTransform, {alphaMultiplier: 0}, Conductor.crochet * 2 / 1000, {startDelay: Conductor.stepCrochet / 1000});
				}
				camGame.zoom += 0.05;
				FlxTween.tween(camGame, {zoom: camGame.zoom - 0.05}, Conductor.crochet / 1000, {ease: FlxEase.quadOut});
			}
		}
	}
	
	if(measure > 8 && !camCancelled)
		if(measure % 2 == 0)
			beatCameraZoom(0.1, 0.15);
}

function ruozhiFuck(fudu:Float) {
	killingAura.alpha = fudu;
	tvShader.redOpac = fudu * 5;
}

function beatCameraZoom(fudu:Float, hud:Float) {
	if(realCamZooming || goodCamZooming) {
		camGame.zoom += fudu;
		camHUD.zoom += fudu;
	}
}

function update(elapsed:Float) {
	if(!camZooming) {
		if(goodCamZooming) {
			camGame.zoom = lerp(camGame.zoom, defaultGoodCamZoom, goodZoomLerp);
			camHUD.zoom = lerp(camHUD.zoom, defaultGoodHUDZoom, goodZoomHUDLerp);
		}
	}
	
	killingAura.alpha = lerp(killingAura.alpha, 0, 0.05);
	tvShader.redOpac = lerp(tvShader.redOpac, 0.15, 0.05);
	chromatic.aberration = lerp(chromatic.aberration, -0.02, 0.1);
}

function postUpdate() {
	camZooming = realCamZooming;
}

function onCameraMove(event) {
	//因为单首歌的加载优先于全局的，所以需要得这么做才能正常使用defaultCamZoom
	cameraMovementChanged = false;
	if(camCancelled) {
		event.cancel();
	}
}

function shoufuTaiwang(time:Float) {
	fwMovies.forEach(function(obj:String) {
		if(obj.ID == 0)
			FlxTween.tween(obj, {y: -1 * obj.height}, time, {ease: FlxEase.quadInOut});
		else FlxTween.tween(obj, {y: FlxG.height}, time, {ease: FlxEase.quadInOut});
	});
}

function qinlveTaiwang(time:Float) {
	fwMovies.forEach(function(obj:String) {
		if(obj.ID == 0)
			FlxTween.tween(obj, {y: 0}, time, {ease: FlxEase.quadInOut});
		else FlxTween.tween(obj, {y: FlxG.height - obj.height}, time, {ease: FlxEase.quadInOut});
	});
}

function setupMovies(group:FlxGroup) {
	for(i in 0...2) {
		var movie = new FlxSprite().makeGraphic(FlxG.width, FlxG.height / 6.5, 0xFF000000);
		movie.ID = i;
		
		movie.y = i * (FlxG.height - movie.height);
		
		group.add(movie);
	}
}

function cameraInsert(cam:FlxCamera, pos:Int, def:Bool = true):FlxCamera {
	if (pos < 0)
	    pos += FlxG.cameras.list.length;
	
    if (pos >= FlxG.cameras.list.length)
        return FlxG.cameras.add(newCamera);
        
    var childIndex = FlxG.game.getChildIndex(FlxG.cameras.list[pos].flashSprite);
    FlxG.game.addChildAt(cam.flashSprite, childIndex);
		
	FlxG.cameras.list.insert(pos, cam);
	if(def)
		defaults.push(cam);

	for (i in pos...FlxG.cameras.list.length)
		FlxG.cameras.list[i].ID = i;
		
	FlxG.cameras.cameraAdded.dispatch(cam);
	return cam;
}