import { Component, OnInit } from "@angular/core";
import { AuthService } from "app/services/auth.service";

declare const $: any;
declare interface RouteInfo {
  path: string;
  title: string;
  icon: string;
  class: string;
  roles: string[];
}
export const ROUTES: RouteInfo[] = [
  {
    path: "/dashboard",
    title: "Dashboard",
    icon: "space_dashboard",
    class: "",
    roles: ["super-admin"],
  },
  {
    path: "/restos",
    title: "Gestion des restos",
    icon: "restaurant",
    class: "",
    roles: ["super-admin", "repreneur", "admin"],
  },
  {
    path: "/vigils",
    title: "Gestion des vigils",
    icon: "supervised_user_circle",
    class: "",
    roles: ["super-admin", "admin"],
  },
  {
    path: "/users",
    title: "Administrateurs",
    icon: "admin_panel_settings",
    class: "",
    roles: ["super-admin"],
  },
  {
    path: "/horaires",
    title: "Gestion des horaires",
    icon: "watch_later",
    class: "",
    roles: ["super-admin",],
  },
  {
    path: "/user-profile",
    title: "Parametres",
    icon: "settings",
    class: "",
    roles: ["super-admin", "admin", "repreneur"],
  },
];

@Component({
  selector: "app-sidebar",
  templateUrl: "./sidebar.component.html",
  styleUrls: ["./sidebar.component.css"],
})
export class SidebarComponent implements OnInit {
  menuItems: any[];
  roles: string[];

  constructor(private authService: AuthService) {}

  ngOnInit() {
    this.menuItems = ROUTES.filter((menuItem) => menuItem);
  }
  isMobileMenu() {
    if ($(window).width() > 991) {
      return false;
    }
    return true;
  }

  hasRoles(route: RouteInfo): boolean {
    let userRoles: string[] = this.authService.getRoles();
    let bool = false;
    route.roles.forEach((role: string) => {
      if (userRoles.some((x) => x === role)) {
        bool = true;
      }
    });
    return bool;
  }
}
