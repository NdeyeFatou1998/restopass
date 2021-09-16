import { RestoListComponent } from "./../../pages/restos/resto-list/resto-list.component";
import { Routes } from "@angular/router";

import { DashboardComponent } from "../../dashboard/dashboard.component";
import { UserProfileComponent } from "../../user-profile/user-profile.component";
import { TableListComponent } from "../../table-list/table-list.component";
import { TypographyComponent } from "../../typography/typography.component";
import { IconsComponent } from "../../icons/icons.component";
import { MapsComponent } from "../../maps/maps.component";
import { NotificationsComponent } from "../../notifications/notifications.component";
import { UpgradeComponent } from "../../upgrade/upgrade.component";
import { VigilListComponent } from "app/pages/vigils/vigil-list/vigil-list.component";
import { UserListComponent } from "app/pages/users/user-list/user-list.component";
import { SuperAdminGuard } from "app/shared/super-admin.guard";
import { HorairesComponent } from "app/pages/params/horaires/horaires.component";

export const AdminLayoutRoutes: Routes = [
  { path: "dashboard", component: DashboardComponent ,canActivate: [SuperAdminGuard] },
  { path: "restos", component: RestoListComponent },
  { path: "vigils", component: VigilListComponent },
  { path: "horaires", component: HorairesComponent },
  { path: "users", component: UserListComponent, canActivate: [SuperAdminGuard] },
  { path: "user-profile", component: UserProfileComponent },
  { path: "table-list", component: TableListComponent },
  { path: "typography", component: TypographyComponent },
  { path: "icons", component: IconsComponent },
  { path: "maps", component: MapsComponent },
  { path: "notifications", component: NotificationsComponent },
  { path: "upgrade", component: UpgradeComponent },
];
